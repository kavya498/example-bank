module "postgress_database" {
  source            = "terraform-ibm-modules/database/ibm//modules/postgresql"
  location          = var.region
  plan              = "standard"
  service_name      = "${var.resource_prefix}-database"
  resource_group_id = data.ibm_resource_group.rg.id
  tags              = ["${var.resource_prefix}:${var.resource_prefix}-location"]
  memory_allocation = 2048
  disk_allocation   = 10240
}
