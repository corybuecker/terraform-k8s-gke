resource "google_storage_bucket" "exlytics-storage" {
  name                        = "bueckered-exlytics-storage"
  location                    = "US"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "exlytics-storage-development" {
  name                        = "bueckered-exlytics-storage-development"
  location                    = "US"
  uniform_bucket_level_access = true
}

data "google_iam_policy" "exlytics-storage-iam" {
  binding {
    role = "roles/storage.admin"
    members = [
      "user:${var.primary_account_email}"
    ]
  }

  binding {
    role = "roles/storage.objectCreator"
    members = [
      "serviceAccount:${google_service_account.gce-service-account.email}",
    ]
  }
}

data "google_iam_policy" "exlytics-storage-development-iam" {
  binding {
    role = "roles/storage.admin"
    members = [
      "user:${var.primary_account_email}"
    ]
  }

  binding {
    role = "roles/storage.objectCreator"
    members = [
      "serviceAccount:${google_service_account.developer-service-account.email}"
    ]
  }
}

resource "google_storage_bucket_iam_policy" "exlytics-storage-policy" {
  bucket      = google_storage_bucket.exlytics-storage.name
  policy_data = data.google_iam_policy.exlytics-storage-iam.policy_data
}

resource "google_storage_bucket_iam_policy" "exlytics-storage-development-policy" {
  bucket      = google_storage_bucket.exlytics-storage-development.name
  policy_data = data.google_iam_policy.exlytics-storage-development-iam.policy_data
}
