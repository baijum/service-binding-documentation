---
sidebar_position: 5
---

# Adding Binding Metadata as OLM Descriptors

Use this method if your Operator is distributed as an [Operator
Bundle](https://github.com/operator-framework/operator-registry/blob/master/docs/design/operator-bundle.md).
You can add [OLM
descriptors](https://github.com/openshift/console/blob/master/frontend/packages/operator-lifecycle-manager/src/components/descriptors/reference/reference.md)
to describe the binding metadata that is to be exposed.  The OLM
descriptors are part of [Cluster Service
Version](https://docs.openshift.com/container-platform/4.7/operators/operator_sdk/osdk-generating-csvs.html)
files.  You can expose the binding data by using `specDescriptors` array and
StatusDescriptors.  The `specDescriptors` array specifies a path under the
`.spec` section of a custom resource.  The `statusDescriptors` array specifies a
path under the `.status` section of a custom resource.

The Service Binding Operator detects the OLM descriptors.  Then the Service
Binding will create a Secret with the values extracted based on the same.
Finally the Service Binding will project the values into the application.

The only two fields used for binding are `Path` and `X-Descriptors`.  **Path**
is a dot-delimited path of the field on the object that the descriptor
describes. The **X-Descriptors** defines the binding meta-data similar to CR/CRD
annotation.

If the path is pointing to a `Secret` resource, there should be an X-Descriptors defined like this:

    urn:alm:descriptor:io.kubernetes:Secret

Similary, if the path is pointing to a `ConfigMap** resource, there should be an
X-Descriptors defined like this:

    urn:alm:descriptor:io.kubernetes:ConfigMap

**Note:**


- You must have a `service.binding` entry in the X-Descriptors to identify that
  it is a configuration for service binding.
- Absence of the `Secret` or `ConfigMap` specific X-Descriptors indicates that
  the descriptor is referencing the binding metadata value at the given path.

## Exposing an entire Secret as the binding Secret

If you are projecting all the values from a `Secret` service resource, you must
specify it as an attribute in the backing service custom resource. For example,
if the attribute is part of the `.spec` section, you can create and use a
`specDescriptors` array. Or, if the attribute is part of the `.status` section,
you can create and use a `statusDescriptors` array.

1. Using the `path` attribute, create an entry to indicate that the path points
   to the `Secret` service resource.

### Example: Configuration with a urn:alm:descriptor:io.kubernetes:Secret entry

```
- path: data.dbCredentials
  x-descriptors:
  - urn:alm:descriptor:io.kubernetes:Secret
  - service.binding
```

## Exposing an entire ConfigMap as the binding Secret

If you are projecting all the values from a `ConfigMap` service resource, you
must specify it as an attribute in the backing service custom resource. For
example, if the attribute is part of the `.spec` section, you can create and use
a `specDescriptors` array. Or, if the attribute is part of the `.status`
section, you can create and use a `statusDescriptors` array.

1. Using the `path` attribute, create an entry to indicate that the path points
   to the `ConfigMap` service resource.

### Example: Configuration with a urn:alm:descriptor:io.kubernetes:ConfigMap entry

```
- path: data.dbConfiguration
  x-descriptors:
  - urn:alm:descriptor:io.kubernetes:ConfigMap
  - service.binding
```

## Exposing an entry from a ConfigMap into the binding Secret

1. Using the `path` attribute, update `X-Descriptors` for `service.binding` and
   `sourceKey` by providing the following information:

- name of the binding key that is to be projected
- name of the key in the Secret service resource

### Example: Configuration with a urn:alm:descriptor:io.kubernetes:ConfigMap entry

```
- path: data.dbConfiguration
  x-descriptors:
  - urn:alm:descriptor:io.kubernetes:ConfigMap
  - service.binding:my_certificate:sourceKey=certificate
```

In the previous example, `sourceKey` points to the name of the key in the Secret
resource, which is `certificate`.  And `my_certificate` is the name of the
binding key that is going to be projected.

## Exposing an entry from a Secret into the binding Secret

1. Using the `path` attribute, update `X-Descriptors` for `service.binding` and
   `sourceKey` by providing the following information:

- name of the binding key that is to be projected
- name of the key in the Secret service resource

### Example: Configuration with a urn:alm:descriptor:io.kubernetes:Secret entry

```
- path: data.dbConfiguration
  x-descriptors:
  - urn:alm:descriptor:io.kubernetes:Secret
  - service.binding:my_certificate:sourceKey=certificate
```

In the previous example, `sourceKey` points to the name of the key in the Secret
resource, which is `certificate`.  And `my_certificate` is the name of the
binding key that is going to be projected.

## Exposing a resource definition value into the binding Secret

If values required for binding to the backing service are available as
attributes of its resources, you can annotate these values, using
`X-Descriptors`.

- Annotating the values identifies them as the binding metadata.
- Content for Procedure: 

1. Using the `path` attribute, update `X-Descriptors` with the required resource definition value.

### Example: The connectionURL attribute pointing to the uri value

```
- path: data.connectionURL
  x-descriptors:
  - service.binding:uri
```

In the previous example, the `connectionURL` attribute points to the required
value that is to be projected as `uri`.

## Exposing the entries of a collection into the binding Secret selecting the key and value from each entry

- Content for Procedure: 

1. Using the `path` attribute, update `X-Descriptors` for the required entries of a collection.

### Example: Configuration from a backing service resource

```
status:
  connections:
    - type: primary
      url: primary.example.com
    - type: secondary
      url: secondary.example.com
    - type: '404'
      url: black-hole.example.com
```

The previous example helps you to project all those values with key such as `primary`,
`secondary`, and so on.

### Example: Configuration for the required entries of a collection

```
- path: bootstrap
  x-descriptors:
  - service.binding:endpoints:elementType=sliceOfMaps:sourceKey=type:sourceValue=url
```

## Exposing the items of a collection into the binding Secret with one key per item


- Content for Procedure: 

1. Using the `path` attribute, update `X-Descriptors` for the required items of a collection.

### Example: Configuration from a backing service resource

```
spec:
    tags:
      - knowledge
      - is
      - power
```

The previous example helps you project all those values with key such as
`prefix_0`, `prefix_1`, and so on.  The default prefix is the name of the
resource kind:

### Example: Configuration for the required items of a collection

```
- path: spec.tags
  x-descriptors:
  - service.binding:tags:elementType=sliceOfStrings
```

## Exposing the values of collection entries into the binding Secret with one key per entry value

- Content for Procedure: 

1. Using the `path` attribute, update `X-Descriptors` for the required values of collection entries.

### Example: Configuration from a backing service resource

```
spec:
    connections:
      - type: primary
        url: primary.example.com
      - type: secondary
        url: secondary.example.com
      - type: '404'
        url: black-hole.example.com
```

The previous example helps you project all those values with key such as
`prefix_0`, `prefix_1`, and so on.  The default prefix is the name of the
resource kind:

### Example: Configuration for the required values of collection entries

```
- path: bootstrap
  x-descriptors:
  - service.binding:endpoints:elementType=sliceOfStrings:sourceValue=url
```
