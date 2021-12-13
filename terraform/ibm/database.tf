# Deploy Databases for Cloud instance of PostgreSQL.
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
resource "ibm_resource_key" "postgress_key" {
  name                 = "${var.resource_prefix}-database-key"
  role                 = "Viewer"
  resource_instance_id = module.postgress_database.postgresql.id
}

# Set up Satellite Links the location and database.
resource "ibm_satellite_endpoint" "postgress_endpoint" {
  location           = module.ibm-location.location_id
  connection_type    = "cloud"
  display_name       = "${var.resource_prefix}-postgress-endpoint"
  server_host        = module.postgress_database.postgresql.connectionstrings[0].hosts[0].hostname
  server_port        = module.postgress_database.postgresql.connectionstrings[0].hosts[0].port
  sni                = module.postgress_database.postgresql.connectionstrings[0].hosts[0].hostname
  client_protocol    = "https"
  client_mutual_auth = false
  server_protocol    = "tls"
  server_mutual_auth = false
  reject_unauth      = false
}
