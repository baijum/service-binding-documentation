---
sidebar_position: 2
---

# Provisioned Service

[Provisioned Service][provisioned-service] is any backing service custom
resource with reference to a Secret resource.  The Secret resource must have all
the values for required for connecting to the backing service.  The reference to
the Secret resource must be available in `.status.binding.name` attribute of the
custom resource.

Here is an example:

```
apiVersion: example.com/v1alpha1
kind: AccountService
name: prod-account-service
spec:
  ...
status:
  binding:
    name: production-db-secret
```

When creating ServiceBinding, the Provisioned Service service can be directly
given in the `.spec.services` section:

```
apiVersion: binding.operators.coreos.com/v1alpha1
kind: ServiceBinding
metadata:
  name: account-service
spec:
  ...
  services:
  - group: "example.com"
    version: v1alpha1
    kind: AccountService
    name: prod-account-service
```

[provisioned-service]: https://github.com/k8s-service-bindings/spec#provisioned-service
