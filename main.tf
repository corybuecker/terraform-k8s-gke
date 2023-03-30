provider "google" {
  project = var.project
  region  = var.region
}

provider "google-beta" {
  project = var.project
  region  = var.region
}

resource "google_service_account" "gce-service-account" {
  account_id   = "${var.base}-id"
  display_name = "Kubernetes cluster service account"
  description  = "Kubernetes cluster service account"
}

resource "google_service_account" "developer-service-account" {
  account_id   = "${var.base}-dev"
  display_name = "Developer service account"
  description  = "Developer service account"
}

resource "google_project_iam_member" "service-account-log-writer-role" {
  project = var.project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gce-service-account.email}"
}

resource "google_project_iam_member" "service-account-metric-writer-role" {
  project = var.project
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gce-service-account.email}"
}

resource "google_project_iam_member" "service-account-metadata-writer-role" {
  project = var.project
  role    = "roles/stackdriver.resourceMetadata.writer"
  member  = "serviceAccount:${google_service_account.gce-service-account.email}"
}

resource "google_project_iam_member" "service-account-artifact-reader-role" {
  project = var.project
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gce-service-account.email}"
}

resource "google_project_iam_member" "service-account-dns-management-role" {
  project = var.project
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.gce-service-account.email}"
}

resource "google_project_iam_member" "service-account-token-creator-role" {
  project = var.project
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.gce-service-account.email}"
}

resource "google_project_iam_member" "developer-service-account-token-creator-role" {
  project = var.project
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.developer-service-account.email}"
}
