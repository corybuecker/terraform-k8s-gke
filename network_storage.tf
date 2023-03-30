resource "google_service_account" "network-storage-service-account" {
  account_id   = "${var.base}-network-storage"
  display_name = "NFS"
  description  = "NFS"
}

resource "google_compute_disk" "network-storage-disk" {
  name = "network-storage-disk"
  type = "pd-balanced"
  zone = "us-central1-a"
  size = "25"
}

resource "google_compute_instance" "network-storage-instance" {
  name         = "network-storage"
  machine_type = "g1-small"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20220924"
      type  = "pd-standard"
    }
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }

  tags = ["${var.base}-network-storage"]

  network_interface {
    subnetwork = google_compute_subnetwork.subnetwork.name
    network_ip = "10.0.1.1"
  }


  service_account {
    email  = google_service_account.network-storage-service-account.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_attached_disk" "network-storage-attached-disk" {
  disk     = google_compute_disk.network-storage-disk.id
  instance = google_compute_instance.network-storage-instance.id
}


resource "google_compute_firewall" "network-storage-ssh" {
  name    = "network-storage-ssh"
  network = google_compute_network.network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "2049"]
  }

  allow {
    protocol = "udp"
    ports    = ["2049"]
  }

  source_ranges = ["11.56.0.0/14", "10.0.0.0/8"]
  target_tags   = ["${var.base}-network-storage"]
}

resource "google_compute_disk_resource_policy_attachment" "network-storage-backup-schedule-attachment" {
  name = google_compute_resource_policy.network-storage-backup-schedule-policy.name
  disk = google_compute_disk.network-storage-disk.name
  zone = "us-central1-a"
}

resource "google_compute_resource_policy" "network-storage-backup-schedule-policy" {
  name   = "network-storage-backup-schedule-policy"
  region = "us-central1"

  snapshot_schedule_policy {
    schedule {
      hourly_schedule {
        hours_in_cycle = 6
        start_time     = "12:00"
      }
    }

    retention_policy {
      max_retention_days = 7
    }
  }
}
