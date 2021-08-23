---
sidebar_position: 1
---

# Introduction

Connecting applications to backing services is always a challenge as each
service provider is suggesting a different way to access their secrets and
consume it in an application.  Service Binding helps the developers by providing
a consistent and predictable experience and removes error-prone usual manual
steps to configure the binding between an application and backing services.

In order for Service Binding operator to provide the binding information, those
needs to be exposed by the backing services in a way that can be detect by
Service Binding. There are basically two main scenarios:

* **The backing service is considered a [Provisioned
  Service][provisioned-service]**: that means that the service you are looking
  to connect to, is compliant to the Service Binding specification and the all
  the binding values will be detected automatically.

* **The backing service is not a [Provisioned Service][provisioned-service]**:
  this means that you'll need to expose the binding metadata from the backing
  service. In this case there are various ways to do that:
  * **[Direct Secret Reference][direct-secret-reference]**: when all the
    required binding values are available in a secret, you can refenrence it in
    your Service Binding definition.
  * **Secret Generated through CRD/CR annotations**: when you can annotate the
    resources of the backing service, so that it exposes the binding metadata
    with specific annotations.
  * **Secret Generated through OLM Descriptors**: when you can provide OLM
    descriptors, if the backing service is provided by an Operator.
  * **Detect Bindings through owned resources**: when the backing service own
    kubernetes resources (Services, Routes, ConfigMaps or Secrets) that can be
    used to look-up for the binding metadatas.

To handle the scenarios of mapping and extracting the binding metadata, Service
Binding Operator provides the ability to extract the values from the backing
service resources and CRDs, in the following way:

1. Extract a string from a resource
2. Extract an entire ConfigMap/Secret referenced from a resource
3. Extract a specific entry from a ConfigMap/Secret referenced from a resource
4. Extract entries from a collection of objects, mapping keys and values from
   entries in a ConfigMap/Secret referenced from a resource
5. Extract a collection of specific entry values in a resource's collection of
   objects
6. Map each value to a specific key
7. Map each value of a collection to a key with generated name

## Data Model

* `path`: A template representation of the path to the element in the Kubernetes
  resource.  The value of path is specified as JSONPath.

* `elementType`: Specifies if the value of the element referenced in `path` is
  of type `string` / `sliceOfStrings` / `sliceOfMaps`.  Defaults to `string` if
  omitted.

* `objectType`: Specifies if the value of the element indicated in `path` refers
  to a `ConfigMap`, `Secret` or a plain string in the current namespace!
  Defaults to `Secret` if omitted and `elementType` is a non-`string`.

* `sourceKey`: Specifies the key in the ConfigMap/Secret to be added to the
  binding Secret. When used in conjunction with `elementType`=`sliceOfMaps`,
  `sourceKey` specifies the key in the slice of maps whose value would be used
  as a key in the binding Secret.  This optional field can be used if the
  operator author intends to express that only when a specific field in the
  referenced `Secret`/`ConfigMap` is bindable.  If the `sourceKey` is not
  specified, all values from the `Secret` or `ConfigMap` will be exposed.

* `sourceValue`: Specifies the key in the slice of maps whose value would be
  used as the value, corresponding to the value of the `sourceKey` which is
  added as the key, in the binding Secret. Mandatory only if `elementType` is
  `sliceOfMaps`.


The data model is same for CRD/CR annotations and OLM descriptors, but the
syntax is different which is explained in respective sections.

[provisioned-service]: https://github.com/k8s-service-bindings/spec#provisioned-service
[direct-secret-reference]: https://github.com/k8s-service-bindings/spec#direct-secret-reference
