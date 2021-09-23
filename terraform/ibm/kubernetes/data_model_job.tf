# apiVersion: batch/v1
# kind: Job
# metadata:
#   name: cc-schema-load
#   labels:
#     app: cc-schema-load
# spec:
#   template:
#     spec:
#       restartPolicy: Never
#       containers:
#         - name: cc-schema-load
#           image: docker.io/ykoyfman/db-load-icd
#           imagePullPolicy: Always
#           envFrom:
#             - secretRef:
#                 name: bank-db-secret

resource "kubernetes_job" "cc_schema_load" {
  metadata {
    name = "cc-schema-load"
    labels = {
      app = "cc-schema-load"
    }
  }
  spec {
    template {
      metadata {}
      spec {
        restart_policy = "Never"
        container {
          name              = "cc-schema-load"
          image             = "docker.io/ykoyfman/db-load-icd"
          image_pull_policy = "Always"
          env_from {
            secret_ref {
              name = "bank-db-secret"
            }
          }
        }
      }
    }
  }
}