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

If it's not the case, please refer to the "exposing binding data" section.

You also required the application ready to create the ServiceBinding resource.

There are two APIs supported by the Service Binding Operator.  Both has
`ServiceBinding` as the same name for the kind.  But the API group is different.

1. binding.operators.coreos.com - This API will be removed in future.
2. service.binding - This API will be supported, but the API group name will changed in future.

Here is the example configuration used in the quick start:


```
apiVersion: binding.operators.coreos.com/v1alpha1
kind: ServiceBinding
metadata:
    name: spring-petclinic-rest
    namespace: petclinic-demo
spec:
    services:
    - group: "crunchydata.com"
      version: v1
      kind: Pgcluster
      name: hippo
    - group: ""
      version: v1
      kind: Secret
      name: hippo-hippo-secret
    application:
      name: spring-petclinic-rest
      group: apps
      version: v1
      resource: deployments
    mappings:
    - name: type
      value: "postgresql"
```

The `.spec.services` is a list of resources related to a service.  There are two
resources in the above configuration, one custom resource and another Secret
resource. 

The first resource kind is `Pgcluster`, API group is `crunchydata.com`, API
version `v1`, and the name of the resource is `hippo`.  This resource annotation
that expose the PostgreSQL database details.  But the username and password is
available as part of other Secret resource.  To allow bindings from the
`spring-petclinic-rest` application, a `type` is also required in the binding
Secret.  That `type` value is set through the `.spec.mappings` with value as
`postgresql`.

The application resource is a deployment resource with name as
`spring-petclinic-rest`.
