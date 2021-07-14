---
sidebar_position: 3
---

# Direct Secret Reference

[Direct Secret Reference][direct-secret-reference] allows to connect to a
service by using Secret as a reference.  This is useful when there is no
Provisioned Service available.

Here is an example:

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

[direct-secret-reference]: https://github.com/k8s-service-bindings/spec#direct-secret-reference
