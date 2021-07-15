---
sidebar_position: 3
---

# Direct Secret Reference

[Direct Secret Reference][direct-secret-reference] allows to connect to a
service by using Secret as a reference.  This is useful when there is no
Provisioned Service available.

Here is an example usage:

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

With spec compliant API:

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
