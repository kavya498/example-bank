
resource "ibm_resource_instance" "appid_instance" {
  name              = "${var.resource_prefix}-appid"
  service           = "appid"
  plan              = "lite"
  location          = var.region
  resource_group_id = var.resource_group_id
  tags              = ["${var.resource_prefix}:${var.location}"]
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}
resource "ibm_resource_key" "appid_key" {
  name                 = "${var.resource_prefix}-appid-key"
  role                 = "Writer"
  resource_instance_id = ibm_resource_instance.appid_instance.id
}
resource "ibm_appid_idp_cloud_directory" "appid_cd" {
  tenant_id                           = ibm_resource_instance.appid_instance.guid
  is_active                           = true
  reset_password_enabled              = true
  reset_password_notification_enabled = true
  self_service_enabled                = true
  signup_enabled                      = true
  welcome_enabled                     = true
  identity_confirm_methods            = ["email"]
  identity_confirm_access_mode        = "OFF"
  identity_field                      = "userName"
}

// Create Application scopes and roles
resource "ibm_appid_application" "appid_application" {
  depends_on = [
    ibm_appid_idp_cloud_directory.appid_cd
  ]
  tenant_id = ibm_resource_instance.appid_instance.guid
  name      = "${var.resource_prefix}-app"
  type      = "regularwebapp"
}
resource "ibm_appid_application_scopes" "scopes" {
  tenant_id = ibm_resource_instance.appid_instance.guid
  client_id = ibm_appid_application.appid_application.client_id
  scopes    = ["admin"]
}
resource "ibm_appid_role" "role" {
  depends_on = [
    ibm_appid_application_scopes.scopes
  ]
  tenant_id = ibm_resource_instance.appid_instance.guid
  name      = "admin"

  access {
    application_id = ibm_appid_application.appid_application.client_id
    scopes         = ["admin"]
  }
}
// Create User and Admin roles to User
# resource "ibm_appid_cloud_directory_user" "admin_user" {
#   tenant_id = ibm_resource_instance.appid_instance.guid
#   email {
#     value = "hkantare@in.ibm.com"
#     primary = true
#   }
#   password = "P@ssw0rd"
#   user_name ="hkantare"
#   display_name="hkantare@in.ibm.com"
# }

data "ibm_iam_auth_token" "token" {
  depends_on = [
    ibm_appid_role.role
  ]
}
resource "null_resource" "admin_user" {
  triggers = {
    TOKEN         = data.ibm_iam_auth_token.token.iam_access_token
    URL           = ibm_resource_key.appid_key.credentials.managementUrl
    REGION        = var.region
    USER_EMAIL    = var.user_email
    USER_NAME     = var.user_name
    USER_PASSWORD = var.user_password
    ROLE          = ibm_appid_role.role.role_id
  }
  provisioner "local-exec" {
    when = create
    environment = {
      TOKEN         = data.ibm_iam_auth_token.token.iam_access_token
      URL           = ibm_resource_key.appid_key.credentials.managementUrl
      REGION        = var.region
      USER_EMAIL    = var.user_email
      USER_NAME     = var.user_name
      USER_PASSWORD = var.user_password
      ROLE          = ibm_appid_role.role.role_id
    }
    command = ". ${path.module}/appid_create.sh"
  }
  provisioner "local-exec" {
    when = destroy
    environment = {
      TOKEN         = self.triggers.TOKEN
      URL           = self.triggers.URL
      REGION        = self.triggers.REGION
      USER_EMAIL    = self.triggers.USER_EMAIL
      USER_NAME     = self.triggers.USER_NAME
      USER_PASSWORD = self.triggers.USER_PASSWORD
      ROLE          = self.triggers.ROLE
    }
    command = ". ${path.module}/appid_destroy.sh"
  }
  lifecycle {
    ignore_changes = [
      triggers
    ]
  }
}


