resource "null_resource" "routes" {
  depends_on = [
    kubernetes_service.mobile_simulator,
    kubernetes_service.transaction_service,
    kubernetes_service.user_service
  ]

  provisioner "local-exec" {
    environment = {
      cluster = data.ibm_container_cluster_config.config.config_file_path
    }
    command = <<-EOT
      export KUBECONFIG=$cluster
      . ${path.module}/scripts/routes.sh
    EOT
  }
}

