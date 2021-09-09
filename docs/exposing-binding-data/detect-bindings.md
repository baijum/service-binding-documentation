---
sidebar_position: 6
---

# Detect Bindings through owned resources

The Service Bindings Operator can detect binding metadata from resources owned
by the backing service custom resource such as Route, Service, ConfigMap, and
Secret resources.

Set this `detectBindingResources` API option to `true` in the `ServiceBinding`
custom resource.

## Example

```
apiVersion: binding.operators.coreos.com/v1alpha1
kind: ServiceBinding
metadata:
  name: etcdbinding
  namespace: service-binding-demo
spec:
  detectBindingResources: true
  application:
    name: java-app
    group: apps
    version: v1
    resource: deployments
  services:
  - group: etcd.database.coreos.com
    version: v1beta2
    kind: EtcdCluster
    name: etcd-cluster-example

```

The Service Binding Operator automatically detects the binding connections and
exposes the binding metadata.
