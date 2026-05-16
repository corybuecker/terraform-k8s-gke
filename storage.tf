resource "random_id" "default" {
  byte_length = 8
}

resource "google_storage_bucket" "terraform" {
  name     = "${random_id.default.hex}-${var.base}-terraform"
  location = "US"

  force_destroy               = false
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}
