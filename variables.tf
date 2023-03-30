variable "region" {
  type    = string
  default = "us-central1"
}

variable "base" {
  type    = string
  default = "texas"
}

variable "primary_account_email" {
  type      = string
  sensitive = true
}

variable "project" {
  type      = string
  sensitive = true
}

variable "domain" {
  type      = string
  sensitive = true
}

variable "master_authorized_networks_config_ip" {
  type      = string
  sensitive = true
}