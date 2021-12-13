resource "null_resource" "serverless_operator" {
  depends_on = [
    kubernetes_service.mobile_simulator,
    null_resource.routes
  ]

  provisioner "local-exec" {
    environment = {
      cluster = data.ibm_container_cluster_config.config.config_file_path
    }
    command = <<-EOT
      export KUBECONFIG=$cluster
      . ${path.module}/scripts/installoperator.sh
    EOT
  }
}
