resource "google_dns_record_set" "dns-mx" {
  name         = google_dns_managed_zone.dns-zone.dns_name
  managed_zone = google_dns_managed_zone.dns-zone.name
  type         = "MX"
  ttl          = 60

  rrdatas = [
    "10 mail.${google_dns_managed_zone.dns-zone.dns_name}",
  ]
}

resource "google_dns_record_set" "dns-mailgun-spf" {
  name         = "mail.${google_dns_managed_zone.dns-zone.dns_name}"
  managed_zone = google_dns_managed_zone.dns-zone.name
  type         = "TXT"
  ttl          = 3600

  rrdatas = [
    "\"v=spf1 include:mailgun.org ~all\"",
  ]
}

resource "google_dns_record_set" "dns-mailgun-domainkey" {
  name         = "smtp._domainkey.mail.${google_dns_managed_zone.dns-zone.dns_name}"
  managed_zone = google_dns_managed_zone.dns-zone.name
  type         = "TXT"
  ttl          = 3600

  rrdatas = [
    ""
  ]
}
