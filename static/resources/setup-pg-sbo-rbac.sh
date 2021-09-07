#!/bin/bash

OPERATOR_NAMESPACE=$(kubectl get deploy --all-namespaces -o json | jq -r '.items[] | select(.metadata.name == "service-binding-operator").metadata.namespace')

kubectl apply -f - << EOD
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: postgrescluster-reader
rules:
- apiGroups: ["postgres-operator.crunchydata.com"]
  resources: ["postgresclusters"]
  verbs: ["get", "watch", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: service-binding-operator-postgrescluster-reader
subjects:
- kind: ServiceAccount
  name: service-binding-operator
  namespace: $OPERATOR_NAMESPACE
roleRef:
  kind: ClusterRole
  name: postgrescluster-reader
  apiGroup: rbac.authorization.k8s.io
EOD
