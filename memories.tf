resource "google_storage_bucket" "bueckered-memories" {
  provider = google-beta

  name                        = "bueckered-memories"
  force_destroy               = true
  uniform_bucket_level_access = true
  location                    = "US"
  public_access_prevention    = "enforced"

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365
    }
  }
}

data "google_iam_policy" "bueckered-memories-policy" {
  binding {
    role = "roles/storage.admin"
    members = [
      "user:${var.primary_account_email}"
    ]
  }

  binding {
    role = "roles/storage.objectViewer"
    members = [
      "serviceAccount:${google_service_account.gce-service-account.email}",
      "serviceAccount:${google_service_account.developer-service-account.email}"
    ]
  }
}

resource "google_storage_bucket_iam_policy" "bueckered-memories-applied-policy" {
  bucket      = google_storage_bucket.bueckered-memories.name
  policy_data = data.google_iam_policy.bueckered-memories-policy.policy_data
}

resource "google_storage_bucket" "bueckered-memories-public" {
  provider = google-beta

  name                        = "bueckered-memories-public"
  force_destroy               = true
  uniform_bucket_level_access = true
  location                    = "US"

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30
    }
  }
}

data "google_iam_policy" "bueckered-memories-public-policy" {
  binding {
    role = "roles/storage.admin"
    members = [
      "user:${var.primary_account_email}",
      "serviceAccount:${google_service_account.gce-service-account.email}",
      "serviceAccount:${google_service_account.developer-service-account.email}"
    ]
  }

  binding {
    role = "roles/storage.objectViewer"
    members = [
      "allUsers"
    ]
  }
}

resource "google_storage_bucket_iam_policy" "bueckered-memories-public-applied-policy" {
  bucket      = google_storage_bucket.bueckered-memories-public.name
  policy_data = data.google_iam_policy.bueckered-memories-public-policy.policy_data
}
