resource "null_resource" "serverless_operator" {

  provisioner "local-exec" {
    environment = {
      cluster = data.ibm_container_cluster_config.config.config_file_path
    }
    command = <<-EOT
      export KUBECONFIG=$cluster
      . ${path.module}/script/installoperator
    EOT
  }
}

