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
