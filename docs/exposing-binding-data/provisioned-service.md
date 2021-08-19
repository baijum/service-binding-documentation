---
sidebar_position: 2
---

# Provisioned Service

[Provisioned Services][provisioned-service] are a way for service authors and provider to be compliant to the specification on the manner they are exposing all the values required for an application to connect to that service. 

To summarize, [Provisioned Service][provisioned-service] represents a backing service custom
resource with a reference to a Secret resource.  The Secret resource provides all
the values required for connecting to the backing service.  The reference to
the Secret resource must be provided in `.status.binding.name` attribute of the
custom resource.

## Specification 

You can refer to the following specification, to learn more about Provisioned Service][provisioned-service]. 


## Example

Let's say you are working on an `AccountService` custom resource representing a
backing service.  As the author of that backing service, you can create a
Secret resource with all the necessary connection details and refer those with `.status.binding.name` field. This way, we will make the `AccountService` conforms to a
Provisioned Service.

This example shows an `AccountService` resource with relavant details:

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

With spec compliant API:

```
apiVersion: service.binding/v1alpha2
kind: ServiceBinding
metadata:
  name: account-service

spec:
  ...
  service:
    apiVersion: example.com/v1alpha1
    kind: AccountService
    name: prod-account-service
```

All the keys in the Secret resource are exposed as binding data and injected into the application.

[provisioned-service]: https://github.com/k8s-service-bindings/spec#provisioned-service
