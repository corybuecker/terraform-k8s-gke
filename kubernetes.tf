resource "google_container_cluster" "container-cluster" {
  name                     = var.base
  location                 = "us-central1-a"
  remove_default_node_pool = true
  initial_node_count       = 1
  networking_mode          = "VPC_NATIVE"
  network                  = google_compute_network.network.self_link
  subnetwork               = google_compute_subnetwork.subnetwork.self_link
  deletion_protection      = false

  ip_allocation_policy {
    cluster_secondary_range_name  = "kubernetes-pods"
    services_secondary_range_name = "kubernetes-services"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = var.master_authorized_networks_config_ip
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "11.3.10.0/28"

    master_global_access_config {
      enabled = false
    }
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  default_snat_status {
    disabled = true
  }

  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }
}

resource "google_container_node_pool" "container-cluster-nodes" {
  provider = google-beta

  cluster    = google_container_cluster.container-cluster.name
  location   = "us-central1-a"
  name       = "${var.base}-pool"
  node_count = 2

  autoscaling {
    min_node_count = 2
    max_node_count = 4
  }

  node_config {
    disk_size_gb    = 10
    machine_type    = "n2d-standard-2"
    spot            = true
    service_account = module.service-accounts["id"].email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    tags            = ["${var.base}-pool-node"]
  }
}

resource "google_compute_firewall" "ingress-controller" {
  name    = "ingress-controller-kubernetes"
  network = google_compute_network.network.name

  allow {
    protocol = "tcp"
    ports    = ["8443", "8080"]
  }

  source_ranges = ["11.3.10.0/28"]
  target_tags   = ["${var.base}-pool-node"]
}
