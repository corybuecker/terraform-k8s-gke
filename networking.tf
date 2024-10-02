resource "google_compute_network" "network" {
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
  name                            = "${var.base}-network"
}

resource "google_compute_subnetwork" "subnetwork" {
  ip_cidr_range            = "10.0.0.0/8"
  name                     = "${var.base}-subnetwork"
  network                  = google_compute_network.network.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "kubernetes-pods"
    ip_cidr_range = "11.56.0.0/14"
  }

  secondary_ip_range {
    range_name    = "kubernetes-services"
    ip_cidr_range = "11.44.0.0/14"
  }
}

resource "google_compute_route" "internet-gateway" {
  name             = "${var.base}-internet-gateway"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.network.name
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
}

resource "google_compute_router" "router" {
  name    = "${var.base}-router"
  region  = google_compute_subnetwork.subnetwork.region
  network = google_compute_network.network.id
}

resource "google_compute_router_nat" "router-nat" {
  name                               = "${var.base}-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
