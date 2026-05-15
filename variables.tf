variable "region" {
  type    = string
  default = "us-central1"
}

variable "base" {
  type    = string
  default = "texas"
}

variable "primary_account_email" {
  type = string
}

variable "project" {
  type = string
}

variable "master_authorized_networks_config_ip" {
  type = string
}

variable "zones" {
  type = list(string)
}

variable "domains" {
  type = set(string)
}