variable "domain" {
  type = string
}

resource "google_dns_managed_zone" "zone" {
  name = "${replace(var.domain, ".", "-")}-zone"
  dns_name = "${var.domain}."

  dnssec_config {
    state = "on"
  }
}
