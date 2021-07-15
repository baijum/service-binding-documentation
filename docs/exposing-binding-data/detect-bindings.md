---
sidebar_position: 6
---

# Detect Bindings through owned resources

The Service Binding Operator binds all information "dependent" to the backing
service CR by populating the binding secret with information from Routes,
Services, ConfigMaps, and Secrets owned by the backing service CR if you express
an intent to extract the same in case the backing service isn't annotated with
the binding metadata.

The binding is initiated by the setting this `detectBindingResources: true` in the ServiceBinding CR:

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
CR and generates a binding secret out of it.
