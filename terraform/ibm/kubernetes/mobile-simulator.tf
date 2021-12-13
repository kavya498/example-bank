resource "kubernetes_deployment" "mobile_simulator" {
  depends_on = [
    kubernetes_service.user_service
  ]
  metadata {
    name = "mobile-simulator-deployment"
    labels = {
      app = "mobile-simulator"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mobile-simulator"
      }
    }
    strategy {
      type = "Recreate"
    }
    template {
      metadata {
        labels = {
          app = "mobile-simulator"
        }
      }
      spec {
        container {
          image             = "ykoyfman/mobile-simulator:css-fix"
          name              = "mobile-simulator"
          image_pull_policy = "Always"
          port {
            container_port = 9080
          }
          env_from {
            secret_ref {
              name = "mobile-simulator-secrets"
            }
          }
          env_from {
            secret_ref {
              name = "bank-oidc-secret"
            }
          }
          env {
            name  = "PORT"
            value = "8080"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mobile_simulator" {
  depends_on = [
    kubernetes_deployment.mobile_simulator
  ]
  metadata {
    name = "mobile-simulator"
    labels = {
      app = "mobile-simulator"
    }
  }
  spec {
    selector = {
      app = "mobile-simulator"
    }
    port {
      port        = 80
      target_port = 8080
      protocol    = "TCP"
    }
    type = "LoadBalancer"
  }
  wait_for_load_balancer = false
}

# apiVersion: v1
# kind: Route
# metadata:
#   name: mobile-simulator-service
# spec:
#   to:
#     kind: Service
#     name: mobile-simulator-service
