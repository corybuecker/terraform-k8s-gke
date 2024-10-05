resource "google_artifact_registry_repository" "repository" {
  provider = google-beta

  location      = "us-central1"
  repository_id = "github-actions-repo"
  format        = "DOCKER"

  cleanup_policies {
    id     = "delete-old"
    action = "DELETE"

    condition {
      tag_state  = "UNTAGGED"
      older_than = "604800s"
    }
  }
}

resource "google_iam_workload_identity_pool" "github-identity-pool" {
  workload_identity_pool_id = "github-identity-pool"
}

resource "google_iam_workload_identity_pool_provider" "github-identity-pool-provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github-identity-pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-identity-pool-provider"
  display_name                       = "GitHub Provider"
  disabled                           = false
  attribute_condition                = var.github_workload_assertion
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

data "google_iam_policy" "repository_policy" {
  binding {
    role = "roles/artifactregistry.reader"
    members = [
      "serviceAccount:${module.service-accounts["id"].email}",
      var.github_workload_principal
    ]
  }

  binding {
    role = "roles/artifactregistry.writer"
    members = [
      var.github_workload_principal
    ]
  }
}

resource "google_artifact_registry_repository_iam_policy" "repository_reader_policy" {
  project    = google_artifact_registry_repository.repository.project
  location   = google_artifact_registry_repository.repository.location
  repository = google_artifact_registry_repository.repository.name

  policy_data = data.google_iam_policy.repository_policy.policy_data
}
