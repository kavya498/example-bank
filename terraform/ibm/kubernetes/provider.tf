data "ibm_container_cluster_config" "config" {
  cluster_name_id = "telas-cluster"
  config_dir      = "./"
  admin           = true
}
provider "kubernetes" {
  host                   = data.ibm_container_cluster_config.config.host
  token                  = data.ibm_container_cluster_config.config.token
  client_certificate     = data.ibm_container_cluster_config.config.admin_certificate
  client_key             = data.ibm_container_cluster_config.config.admin_key
  cluster_ca_certificate = data.ibm_container_cluster_config.config.ca_certificate
  experiments {
    manifest_resource = true
  }
}
