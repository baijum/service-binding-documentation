---
sidebar_position: 1
---

# Creating Service Binding

In this section, we consider that the service you want to connect to is already
exposing binding metadata by either:

1. Provisioned Service
2. Direct Secret Reference
3. Secret Generated  through CRD/CR annotations
4. Secret Generated through OLM Descriptors
5. Detect Bindings through owned resources

You also required the application ready before creating the ServiceBinding
resource.

There are two APIs supported by the Service Binding Operator.  Both has
`ServiceBinding` as the same name for the kind.  But the API group is different.

1. `binding.operators.coreos.com`
2. `service.binding` (API group used in the [Service Binding Spec][spec])

Here is the example configuration with `binding.operators.coreos.com` API group:

```
apiVersion: binding.operators.coreos.com/v1alpha1
kind: ServiceBinding
metadata:
  name: account-service
spec:
  application:
    apiVersion: apps/v1
    kind: Deployment
    name: online-banking

  services:
  - apiVersion: example.com/v1alpha1
    kind: AccountService
    name: prod-account-service
```

Here is the same example with `service.binding` API group:

```
apiVersion: service.binding/v1alpha2
kind: ServiceBinding
metadata:
  name: account-service
spec:
  application:
    apiVersion: apps/v1
    kind: Deployment
    name: online-banking

  service:
    apiVersion: example.com/v1alpha1
    kind: AccountService
    name: prod-account-service
```

The `.spec.services` is a list of resources related to a service. The second API
only supports only one service.  The service kind is `Database`, API group is
`example.com`, API version `v1alpha1`, and the name of the resource is
`prod-account-service`.

The application resource is a deployment resource with name as
`online-banking`.

[spec]: https://github.com/k8s-service-bindings/spec
