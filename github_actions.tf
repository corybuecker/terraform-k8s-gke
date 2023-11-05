resource "google_artifact_registry_repository" "github-actions-repo" {
  provider = google-beta

  location      = "us-central1"
  repository_id = "github-actions-repo"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "member" {
  provider = google-beta

  project    = google_artifact_registry_repository.github-actions-repo.project
  location   = google_artifact_registry_repository.github-actions-repo.location
  repository = google_artifact_registry_repository.github-actions-repo.name
  role       = "roles/artifactregistry.repoAdmin"
  member     = "serviceAccount:${module.service-accounts["github-actions"].email}"
}
