data "ibm_resource_group" "rg" {
  name = var.resource_group
}
locals {
  location_zones = [for index in range(3) : "${var.region}-${index + 1}"]
  cluster_zones  = [for index in range(1) : "${var.region}-${index + 1}"]
}
module "ibm-location" {
  source          = "github.com/kavya498/terraform-ibm-satellite//examples/satellite-ibm"
  ibm_region      = var.region
  resource_group  = var.resource_group
  location        = "${var.resource_prefix}-location"
  managed_from    = var.managed_from
  location_zones  = local.location_zones
  host_labels     = ["${var.resource_prefix}:location"]
  host_count      = 3
  addl_host_count = 2
  is_prefix       = var.resource_prefix
}
// TO DO: Add all all inbound security rule

resource "ibm_satellite_cluster" "create_cluster" {
  name                   = "${var.resource_prefix}-cluster"
  location               = module.ibm-location.location_id
  enable_config_admin    = false
  resource_group_id      = data.ibm_resource_group.rg.id
  host_labels            = ["${var.resource_prefix}:location"]
  wait_for_worker_update = true
  worker_count           = 2
  dynamic "zones" {
    for_each = local.cluster_zones
    content {
      id = zones.value
    }
  }
}
module "satellite_network" {
  source   = "./network"
  cluster  = ibm_satellite_cluster.create_cluster.id
  location = module.ibm-location.location_id
  publicip = module.ibm-location.fip_addresses
}
