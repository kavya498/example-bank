resource "kubernetes_deployment" "transaction_service" {
  depends_on = [
    kubernetes_job.cc_schema_load
  ]
  metadata {
    name = "terraform-example"
    labels = {
      app = "transaction-service"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "transaction-service"
      }
    }
    template {
      metadata {
        labels = {
          app = "transaction-service"
        }
        annotations = {
          "sidecar.istio.io/inject" = "false"
        }
      }
      spec {
        container {
          image             = "ykoyfman/bank-transaction-service:1.0"
          name              = "transaction-service"
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
          env {
            name  = "USER_SERVICE_URL"
            value = "http://user-service:9080/bank/v1/users"
          }
          env {
            name  = "KNATIVE_SERVICE_URL"
            value = "http://process-transaction.example-bank.svc.cluster.local"
          }
          env {
            name  = "WLP_LOGGING_CONSOLE_LOGLEVEL"
            value = "INFO"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "transaction_service" {
  depends_on = [
    kubernetes_deployment.transaction_service
  ]
  metadata {
    name = "transaction-service"
    labels = {
      app = "transaction-service"
    }
  }
  spec {
    selector = {
      app = "transaction-service"
    }
    session_affinity = "ClientIP"
    port {
      port        = 9080
      target_port = 9080
    }
  }
}


# apiVersion: v1
# kind: Route
# metadata:
#   name: transaction-service
# spec:
#   to:
#     kind: Service
#     name: transaction-service

# ./installServerlessOperator.sh