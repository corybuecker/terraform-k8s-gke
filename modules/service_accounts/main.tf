variable "project" {
  type = string
}

variable "account" {
  type = string
}

variable "roles" {
  type = list(string)
}

variable "workload-identities" {
  type = list(string)
}

resource "google_service_account" "service-account" {
  account_id   = var.account
  display_name = "K8s cluster service account"
  description  = "K8s cluster service account"
}

resource "google_project_iam_member" "service-account-role" {
  for_each = toset(var.roles)
  project = var.project
  role    = each.key
  member  = "serviceAccount:${google_service_account.service-account.email}"
}

resource "google_service_account_iam_binding" "workload-identity-binding" {
  for_each = toset(var.workload-identities)
  service_account_id = google_service_account.service-account.id
  role    = "roles/iam.workloadIdentityUser"
  members = ["serviceAccount:${var.project}.svc.id.goog[${each.key}]"]
}

output "id" {
  value = google_service_account.service-account.id
}

output "email" {
  value = google_service_account.service-account.email
}
