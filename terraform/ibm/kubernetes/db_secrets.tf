resource "kubernetes_secret" "db_secret" {
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
