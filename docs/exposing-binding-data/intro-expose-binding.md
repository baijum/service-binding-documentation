---
sidebar_position: 1
---

# Introduction

Connecting applications to backing services is always a challenge as each
service provider suggests a different way to access their secrets and consume
them in an application.  Service Binding helps the developers by providing a
consistent and predictable experience and removes error-prone usual manual steps
to configure the binding between an application and backing services.

For the Service Binding Operator to provide the binding metadata, the backing
services must expose the binding metadata in a way that can be detected by
Service Binding Operator.

Binding metadata is exposed for the following scenarios:
 
* **The backing service is considered as a [Provisioned
  Service][provisioned-service]** resource: The service you intend to connect
  to, is compliant with the Service Binding specification and the detection of
  all the binding metadata values is automatic.

* **The backing service is not a [Provisioned Service][provisioned-service]**
  resource: You must expose the binding metadata from the backing service.  You
  can expose the binding metadata using any of the following methods:
  * **[Direct Secret Reference][direct-secret-reference]**: When all the
    required binding values are available in a `Secret` that you can reference
    in your Service Binding definition.
  * **Generate Secret through CRD or CR annotations**: When you can annotate the
    resources of the backing service, to expose the binding metadata with
    specific annotations.
  * **Generate Secret through OLM descriptors**: when you can provide OLM
    descriptors, if the backing service is provided by an Operator.
  * **Detect Binding metadata through owned resources**: when the backing
    service owns Kubernetes resources such as `Service`, `Route`, `ConfigMap` or
    `Secret` that you can use to detect the binding metadata.

Service Binding Operator provides the ability to expose the values from the
backing service resources and CRDs.  You can use the following methods to map
and expose the binding metadata:

- Expose a string from a resource
- Expose an entire ConfigMap or Secret that is referenced from a resource
- Expose a specific entry from a ConfigMap or Secret that is referenced from a resource
- Expose entries from a collection of objects, mapping keys and values from
  entries in a ConfigMap or Secret that is referenced from a resource
- Expose a collection of specific entry values in a resource's collection of
  objects
- Map each value to a specific key
- Map each value of a collection to a key with a generated name

## Data Model

This section explains the data model used in the annotation and OLM descripors.
The data model is same for CRD or CR annotations and OLM descriptors, but the
syntax is different, which is explained in the respective sections.

* `path`: A template representation of the path to the element in the Kubernetes
  resource.  The value of `path` is specified as JSONPath.

* `elementType`: Specifies whether the value of the element referenced in `path`
   complies with any one of the following types `string` or `sliceOfStrings` or
   `sliceOfMaps`.  Defaults to `string` if `elementType` is not specified.

* `objectType`: Specifies whether the value of the element indicated in `path`
  refers to a `ConfigMap`, `Secret` or a plain string in the current namespace!
  Defaults to `Secret` if `objectType` is not specified and `elementType` is
  non-string.

* `sourceKey`: Specifies the key in the ConfigMap or Secret that is to be added
  to the binding Secret.  When used in conjunction with
  `elementType`=`sliceOfMaps`, `sourceKey` specifies the key in the slice of
  maps whose value would be used as a key in the binding Secret.  This optional
  field can be used if the operator author intends to express that when a
  specific field in the referenced `Secret` or `ConfigMap` is bindable.  All
  values from `Secret` or `ConfigMap` are exposed if `sourceKey` is not
  specified.

* `sourceValue`: Specifies the key in the slice of maps whose value would be
  used as the value, corresponding to the value of the `sourceKey` that is added
  as the key, in the binding Secret.  Mandatory only if `elementType` is
  `sliceOfMaps`.

[provisioned-service]: https://github.com/k8s-service-bindings/spec#provisioned-service
[direct-secret-reference]: https://github.com/k8s-service-bindings/spec#direct-secret-reference
