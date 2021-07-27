---
sidebar_position: 6
---

# Detect Bindings through owned resources

The Service Bindings operator can detect binding from resources owned by the
service custom resource.  Service Binding operator can detect Routes, Services,
ConfigMaps, and Secrets owned by the backing service custom resource.
Annotation is not required to extract the binding data.

This option is initiated by the setting `detectBindingResources: true` in the
ServiceBinding custom resource:

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

When this API option is set to true, the Service Binding Operator automatically
detects Routes, Services, ConfigMaps, and Secrets owned by the backing service
CR and expose the binding data.
