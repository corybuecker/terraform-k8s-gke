resource "google_artifact_registry_repository" "repository" {
  location      = "us-central1"
  repository_id = "${var.base}"
  format        = "DOCKER"
}