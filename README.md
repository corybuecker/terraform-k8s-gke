# Terraform a Kubernetes cluster in the Google Kubernetes Engine

## Secrets

There are a number of input variables that Terraform expects in an `[name].auto.tfvars` file. I just use `secrets.auto.tfvars`.

- primary_account_email = "primary email for Google Cloud account"
- project = "internal Google Cloud project ID"
- master_authorized_networks_config_ip = "an IP address that should have access to the control plane"
- github_workload_assertion = "assertion constraint for a GitHub integration"
- github_workload_principal = "principalSet name for a GitHub integration"
- zones = "list of domain names to be managed by external-dns"

## Provision

Just run `terraform plan`, and if everything looks OK, run `terraform apply`.
