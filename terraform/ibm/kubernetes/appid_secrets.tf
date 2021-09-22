resource "kubernetes_secret" "oidc_secret" {
  metadata {
    name = "bank-oidc-secret"
  }
  data = {
    OIDC_JWKENDPOINTURL   = "${var.oauth_server_url}/publickeys"
    OIDC_ISSUERIDENTIFIER = var.oauth_server_url
    OIDC_AUDIENCES        = var.client_id
  }
  type = "generic"
}

resource "kubernetes_secret" "appid_secret" {
  metadata {
    name = "bank-appid-secret"
  }
  data = {
    APPID_TENANTID    = var.tenant_id
    APPID_SERVICE_URL = var.profiles_url
  }
  type = "generic"
}

resource "kubernetes_secret" "iam_secret" {
  metadata {
    name = "bank-iam-secret"
  }
  data = {
    IAM_APIKEY      = var.ibmcloud_api_key
    IAM_SERVICE_URL = "https://iam.cloud.ibm.com/identity/token"
  }
  type = "generic"
}

resource "kubernetes_secret" "simulator_secrets" {
  metadata {
    name = "mobile-simulator-secrets"
  }
  data = {
    APP_ID_IAM_APIKEY              = var.ibmcloud_api_key
    APP_ID_MANAGEMENT_URL          = var.appid_link_endpoint
    APP_ID_CLIENT_ID               = var.client_id
    APP_ID_CLIENT_SECRET           = var.secret
    APP_ID_TOKEN_URL               = var.oauth_server_url
    PROXY_USER_MICROSERVICE        = "user-service:9080"
    PROXY_TRANSACTION_MICROSERVICE = "transaction-service:9080"
  }
  type = "generic"
}

resource "kubernetes_secret" "oidc_adminuser" {
  metadata {
    name = "bank-oidc-adminuser"
  }
  data = {
    APP_ID_ADMIN_USER     = "bankadmin"
    APP_ID_ADMIN_PASSWORD = "password"
  }
  type = "generic"
}
