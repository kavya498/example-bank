echo "Creating transaction-service route"
cat <<EOF | oc apply -f -
apiVersion: v1
kind: Route
metadata:
  name: transaction-service
spec:
  to:
    kind: Service
    name: transaction-service
EOF
sleep 5


echo "Creating user-service route"
cat <<EOF | oc apply -f -
apiVersion: v1
kind: Route
metadata:
  name: user-service
spec:
  to:
    kind: Service
    name: user-service
EOF
sleep 5


echo "Creating mobile-simulator route"
cat <<EOF | oc apply -f -
apiVersion: v1
kind: Route
metadata:
  name: mobile-simulator-service
spec:
  to:
    kind: Service
    name: mobile-simulator-service
EOF
sleep 5

