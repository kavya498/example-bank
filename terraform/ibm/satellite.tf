module "ibm-location" {
  source          = "github.com/terraform-ibm-modules/terraform-ibm-satellite//examples/satellite-ibm"
  ibm_region      = "us-east"
  resource_group  = "Default"
  location        = "cp-location"
  managed_from    = "wdc04"
  location_zones  = ["us-east-1", "us-east-2", "us-east-3"]
  host_labels     = ["cp:location"]
  host_count      = 3
  addl_host_count = 2
  is_prefix       = "cp"
}
data "ibm_resource_group" "rg"{
    name ="Default"
}
provider ibm {
    region = "us-east"
}
resource "ibm_satellite_cluster" "create_cluster" {
    depends_on=[module.ibm-location]
    name                   = "cp-cluster"  
    location               = "cp-location"
    enable_config_admin    = false
    # kube_version           = "4.5_openshift"
    resource_group_id      = data.ibm_resource_group.rg.id
    host_labels     = ["cp:location"]
    wait_for_worker_update = true
    worker_count=2
    dynamic "zones" {
        for_each = var.zones
        content {
            id  = zones.value
        }
    }
}

variable zones {
    default = ["us-east-1"]
}