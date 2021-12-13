resource "null_resource" "process_transaction" {
  depends_on = [
    null_resource.serverless_operator
  ]

  provisioner "local-exec" {
    environment = {
      cluster = data.ibm_container_cluster_config.config.config_file_path
    }
    command = <<-EOT
      export KUBECONFIG=$cluster
      echo "Creating transaction-service route"
cat <<EOF | oc apply -f -
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: process-transaction
  # local to cluster only
  labels:
    serving.knative.dev/visibility: cluster-local
spec:
  template:
    metadata:
      annotations:
        # Target 10 requests in-flight per pod.
        autoscaling.knative.dev/target: "10"
        # Disable scale to zero with a minScale of 1.
        # autoscaling.knative.dev/minScale: "1"
        # Limit scaling to 50 pods.
        # autoscaling.knative.dev/maxScale: "50"
    spec:
      containers:
        - image: anthonyamanse/knative-transaction-process:with-auth
          envFrom:
            - secretRef:
                name: bank-oidc-adminuser
            - secretRef:
                name: mobile-simulator-secrets
          env:
            - name: TRANSACTION_SERVICE_URL
              value: "http://transaction-service:9080/bank/v1/transactions"
EOF
sleep 5

    EOT
  }
}


