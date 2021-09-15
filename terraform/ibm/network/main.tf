data ibm_container_nlb_dns nlb_dns {
    cluster = var.cluster
}
data "ibm_iam_auth_token" "token" {}

resource "null_resource" "disassociate_privateip"{
    provisioner "local-exec" {
    environment = {
      TOKEN               = data.ibm_iam_auth_token.token.iam_access_token
      CLUSTER              = var.cluster
      HOST      = data.ibm_container_nlb_dns.nlb_dns.nlb_config[0].nlb_sub_domain
      IP = data.ibm_container_nlb_dns.nlb_dns.nlb_config[0].nlb_ips[0]
    }
    command = <<EOT
          curl -X DELETE "https://containers.cloud.ibm.com/global/v1/nlb-dns/clusters/$CLUSTER/host/$HOST/ip/$IP/remove" -H "Authorization: $TOKEN"
        EOT
  }
}
resource "null_resource" "add_publicip"{
    provisioner "local-exec" {
    environment = {
      TOKEN               = data.ibm_iam_auth_token.token.iam_access_token
      CLUSTER              = var.cluster
      HOST      = data.ibm_container_nlb_dns.nlb_dns.nlb_config[0].nlb_sub_domain
      IP = var.publicip
    }
    command = <<EOT
          curl -X PUT "https://containers.cloud.ibm.com/global/v1/nlb-dns/clusters/$CLUSTER/add" -H "Authorization: $TOKEN" -H  "Content-Type: application/json" -d "{  \"clusterID\": \"$CLUSTER\",  \"nlbHost\": \"$HOST\",  \"nlbIPArray\": $IP}"
        EOT
  }
}
data ibm_satellite_location_nlb_dns dns {
    location = var.location
}
resource "null_resource" "register_dns"{
    provisioner "local-exec" {
    environment = {
      TOKEN               = data.ibm_iam_auth_token.token.iam_access_token
      REFRESHTOKEN               = data.ibm_iam_auth_token.token.iam_refresh_token
      LOCATION              = var.location
      HOST      = data.ibm_container_nlb_dns.nlb_dns.nlb_config[0].nlb_sub_domain
      IP = var.publicip
    }
    command = <<EOT
          curl -X POST "https://containers.cloud.ibm.com/global/v2/nlb-dns/registerMSCDomains" -H  "accept: application/json" -H  "Authorization: $TOKEN" -H  "X-Auth-Refresh-Token: $REFRESHTOKEN" -H  "Content-Type: application/json" -d "{  \"controller\": \"$LOCATION\",  \"ips\": $IP}"
        EOT
  }
}
