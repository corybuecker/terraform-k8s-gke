resource "google_certificate_manager_certificate_map" "certificate_map" {
  name = "${var.base}-certificate-map"
}

module "certificates" {
  for_each = var.domains
  source   = "./modules/certificates"
  domain   = each.key
}

resource "google_certificate_manager_certificate_map_entry" "certificate_map_entry" {
  for_each     = module.certificates
  name         = replace(each.value.domain, ".", "-")
  map          = google_certificate_manager_certificate_map.certificate_map.name
  certificates = [each.value.id]
  hostname     = each.value.domain
}
