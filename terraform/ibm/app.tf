module "application" {
  source            = "./appid"
  resource_group_id = data.ibm_resource_group.rg.id
  resource_prefix   = var.resource_prefix
  region            = var.region
  location          = "${var.resource_prefix}-location"
  user_email        = var.user_email
  user_name         = var.user_name
  user_password     = var.user_password
}
resource "ibm_satellite_endpoint" "app_endpoint" {
  location           = module.ibm-location.location_id
  connection_type    = "cloud"
  display_name       = "${var.resource_prefix}-appid-endpoint"
  server_host        = nonsensitive(local.host[1])
  server_port        = 443
  sni                = nonsensitive(local.host[1])
  client_protocol    = "https"
  client_mutual_auth = false
  server_protocol    = "tls"
  server_mutual_auth = false
  reject_unauth      = false
  lifecycle {
    ignore_changes =[
      server_host,sni,created_by
    ]
  }
}
locals {
  host = split("//", module.application.appid_credentials.appidServiceEndpoint)
}