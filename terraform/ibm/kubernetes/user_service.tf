resource "kubernetes_deployment" "user_service" {
  depends_on = [
    kubernetes_service.transaction_service
  ]
  metadata {
    name = "user-service"
    labels = {
      app = "user-service"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "user-service"
      }
    }
    template {
      metadata {
        labels = {
          app = "user-service"
        }
      }
      spec {
        container {
          image             = "anthonyamanse/user-service:example-bank-1.0"
          name              = "user-service"
          image_pull_policy = "Always"
          port {
            name           = "http-server"
            container_port = 9080
          }
          env_from {
            secret_ref {
              name = "bank-db-secret"
            }
          }
          env_from {
            secret_ref {
              name = "bank-oidc-secret"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "user_service" {
  depends_on = [
    kubernetes_deployment.user_service
  ]
  metadata {
    name = "user-service"
    labels = {
      app = "user-service"
    }
  }
  spec {
    selector = {
      app = "user-service"
    }
    port {
      port        = 9080
      target_port = 9080
    }
  }
}


# apiVersion: v1
# kind: Route
# metadata:
#   name: user-service
# spec:
#   to:
#     kind: Service
#     name: user-service

module "user_service_route" {
  depends_on = [
    kubernetes_service.user_service
  ]
  source              = "github.com/terraform-ibm-modules/terraform-ibm-cluster//modules/openshift-route"
  ibmcloud_api_key    = var.ibmcloud_api_key
  cluster_service_url = var.cluster_service_url
  namespace           = var.namespace
  route_data          = var.user_route_data
}

variable "user_route_data" {
  default = <<EOT
  {
   "kind":"Route",
   "apiVersion":"route.openshift.io/v1",
   "metadata":{
      "name":"user-service"
   },
   "spec":{
      "to":{
         "kind":"Service",
         "name":"user-service"
      }
   }
}
EOT
}