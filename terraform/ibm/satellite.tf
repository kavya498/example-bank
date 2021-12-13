data "ibm_resource_group" "rg" {
  name = var.resource_group
}
locals {
  location_zones = [for index in range(3) : "${var.region}-${index + 1}"]
  cluster_zones  = [for index in range(1) : "${var.region}-${index + 1}"]
  sg_rules = [
    for r in local.rules : {
      name       = r.name
      direction  = r.direction
      remote     = lookup(r, "remote", null)
      ip_version = lookup(r, "ip_version", null)
      icmp       = lookup(r, "icmp", null)
      tcp        = lookup(r, "tcp", null)
      udp        = lookup(r, "udp", null)
    }
  ]
  rules = [
    {
      name      = "${var.resource_prefix}-ingress-1"
      direction = "inbound"
    }
  ]
}
# Create a Satellite location in IBM Cloud.
# Modify the server attachment script
# Deploy infrastructure for a Satellite location on IBM-Cloud by provisioning RHEL VMs from a template.
# Assign three IBM VMs to the Satellite Location control plane.
module "ibm-location" {
  source           = "github.com/kavya498/terraform-ibm-satellite//examples/satellite-ibm"
  ibm_region       = var.region
  resource_group   = var.resource_group
  location         = "${var.resource_prefix}-location"
  managed_from     = var.managed_from
  location_zones   = local.location_zones
  host_labels      = ["${var.resource_prefix}:location"]
  host_count       = 3
  addl_host_count  = 2
  is_prefix        = var.resource_prefix
  location_profile = var.location_profile
  cluster_profile  = var.cluster_profile
}

// TO DO: Add all all inbound security rule
module "default_sg_rules" {
  source  = "terraform-ibm-modules/vpc/ibm//modules/security-group"
  version = "1.0.0"

  create_security_group = false
  resource_group_id     = data.ibm_resource_group.rg.id
  security_group        = module.ibm-location.default_security_group
  security_group_rules  = local.sg_rules
}
# Set up a RedHat OpenShift Cluster in the satellite location.
# Assign VMs to the OpenShift Cluster.
resource "ibm_satellite_cluster" "create_cluster" {
  depends_on = [
    module.ibm-location
  ]
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
# Networking https://github.com/kavya498/example-bank/tree/satellite#networking
module "satellite_network" {
  source   = "./network"
  cluster  = ibm_satellite_cluster.create_cluster.id
  location = module.ibm-location.location_id
  publicip = module.ibm-location.floating_ip_addresses
}
