provider "google" {
  project = var.project
  region  = var.region
}

provider "google-beta" {
  project = var.project
  region  = var.region
}

module "service-accounts" {
  for_each = {
    id = {
      roles : [
        "roles/logging.logWriter",
        "roles/monitoring.metricWriter",
        "roles/stackdriver.resourceMetadata.writer",
        "roles/artifactregistry.reader",
        "roles/iam.serviceAccountTokenCreator"
      ],
      workload-identities : []
    }
    dev            = { roles : ["roles/iam.serviceAccountTokenCreator"], workload-identities : [] }
    github-actions = { roles : [], workload-identities : [] }
    # external-dns   = { roles : ["roles/dns.admin"], workload-identities : ["external-dns/external-dns"] }
  }
  source              = "./modules/service_accounts"
  account             = "${var.base}-${each.key}"
  project             = var.project
  roles               = each.value.roles
  workload-identities = each.value.workload-identities
}
