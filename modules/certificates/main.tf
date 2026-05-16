variable "domain" {
  type = string
}

resource "google_certificate_manager_dns_authorization" "dns_authorization" {
  name   = replace(var.domain, ".", "-")
  domain = var.domain
}

resource "google_certificate_manager_certificate" "certificate" {
  name  = replace(var.domain, ".", "-")

  managed {
    domains = [
      google_certificate_manager_dns_authorization.dns_authorization.domain
    ]
    
    dns_authorizations = [
      google_certificate_manager_dns_authorization.dns_authorization.id
    ]
  }
}

output "id" {
    value = google_certificate_manager_certificate.certificate.id
}

output "domain" {
    value = var.domain
}