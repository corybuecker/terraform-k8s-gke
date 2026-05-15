provider "google" {
  project     = var.project
  region      = var.region
}

provider "google-beta" {
  project     = var.project
  region      = var.region
}

module "service-accounts" {
  for_each = {
    node = {
      roles : [
        "roles/container.defaultNodeServiceAccount",
        "roles/artifactregistry.reader"
      ],
      workload-identities : []
    }
  }
  source              = "./modules/service_accounts"
  account             = "${var.base}-${each.key}"
  project             = var.project
  roles               = each.value.roles
  workload-identities = each.value.workload-identities
}
