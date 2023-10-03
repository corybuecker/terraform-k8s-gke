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
    external-dns   = { roles : ["roles/dns.admin"], workload-identities : ["external-dns/external-dns"] }
  }
  source              = "./modules/service_accounts"
  account             = "${var.base}-${each.key}"
  project             = var.project
  roles               = each.value.roles
  workload-identities = each.value.workload-identities
}

resource "google_iam_workload_identity_pool" "workload-identity-pool" {
  workload_identity_pool_id = "${var.base}-pool"
}

resource "google_iam_workload_identity_pool_provider" "workload-identity-pool-provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.workload-identity-pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "${var.base}-pool-provider"
  attribute_mapping = {
    "google.subject"       = "assertion.sub",
    "attribute.actor"      = "assertion.actor",
    "attribute.repository" = "assertion.repository"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_binding" "github-actions-policy-binding" {
  service_account_id = module.service-accounts["github-actions"].id
  role               = "roles/iam.workloadIdentityUser"

  members = [
    var.github_workload_principal
  ]
}
