module "zones" {
  for_each = toset(var.zones)
  source   = "./modules/cloud_dns_domains"
  domain   = each.key
}
