resource "kubernetes_deployment" "process_transaction" {

  metadata {
    name = "process-transaction"
    labels = {
      "serving.knative.dev/visibility" = "cluster-local"
    }
  }

  spec {
    template {
      metadata {
        annotations = {
          "autoscaling.knative.dev/target" = "10"
        }
      }
      spec {
        container {
          image = "anthonyamanse/knative-transaction-process:with-auth"
          name  = "process-transaction"
          env_from {
            secret_ref {
              name = "mobile-simulator-secrets"
            }
          }
          env_from {
            secret_ref {
              name = "bank-oidc-adminuser"
            }
          }
          env {
            name  = "TRANSACTION_SERVICE_URL"
            value = "http://transaction-service:9080/bank/v1/transactions"
          }
        }
      }
    }
  }
}