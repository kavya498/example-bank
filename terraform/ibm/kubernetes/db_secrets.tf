resource "kubernetes_secret" "db_secret" {
  depends_on = [
    kubernetes_secret.oidc_secret,
    kubernetes_secret.appid_secret,
    kubernetes_secret.iam_secret,
    kubernetes_secret.simulator_secrets,
    kubernetes_secret.oidc_adminuser
  ]
  metadata {
    name = "bank-db-secret"
  }
  data = {
    DB_SERVERNAME   = var.db_host
    DB_PORTNUMBER   = var.db_port
    DB_DATABASENAME = var.db_name
    DB_USER         = var.db_user
    DB_PASSWORD     = var.db_password
  }
  type = "generic"
}
