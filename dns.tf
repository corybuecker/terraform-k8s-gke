resource "google_dns_managed_zone" "dns-zone" {
  name        = "${var.base}-zone"
  dns_name    = "${var.domain}."
  description = "${var.base} zone"

  dnssec_config {
    state = "on"
  }
}


