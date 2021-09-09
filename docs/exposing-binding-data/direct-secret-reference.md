---
sidebar_position: 3
---

# Direct Secret Reference

When a resource is not available as a Provisioned Service, but there is a
`Secret` service resource available for binding, use the [Direct Secret
Reference][direct-secret-reference] method.  In this method, a `ServiceBinding`
resource directly references a `Secret` service resource to connect to a
service.  All the keys in the `Secret` service resource are exposed as binding
metadata.

## Example: Specification with the binding.operators.coreos.com API

```
apiVersion: binding.operators.coreos.com/v1alpha1
kind: ServiceBinding
metadata:
  name: account-service
spec:
  ...
  services:
  - group: ""
    version: v1
    kind: Secret
    name: production-db-secret
```

## Example: Specification that is compliant with the service.binding API

```
apiVersion: service.binding/v1alpha2
kind: ServiceBinding
metadata:
  name: account-service

spec:
  ...
  service:
    apiVersion: v1
    kind: Secret
    name: production-db-secret
```

[direct-secret-reference]: https://github.com/k8s-service-bindings/spec#direct-secret-reference
