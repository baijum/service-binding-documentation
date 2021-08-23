---
sidebar_position: 5
---

# Adding Binding Metadata as OLM Descriptors

If your operator is distributed as an [Operator
Bundle](https://github.com/operator-framework/operator-registry/blob/master/docs/design/operator-bundle.md),
you can add [OLM
descriptors](https://github.com/openshift/console/blob/master/frontend/packages/operator-lifecycle-manager/src/components/descriptors/reference/reference.md)
to describe what binding data are exposed.  The OLM descriptors are part of
[Cluster Service
Version](https://docs.openshift.com/container-platform/4.7/operators/operator_sdk/osdk-generating-csvs.html)
files.  To expose the binding data, you can use SpecDescriptors and
StatusDescriptors.  To specify a path under the `.spec` of a custom resource,
use SpecDescriptors.  Similarly, to specify a path under `.status` of a custom
resource, use StatusDescriptors.

The Service Binding will detect the OLM descriptors.  Then the Service Binding
will create a Secret with the values extracted based on the same.  Finally the
Service Binding will inject the values into the application.

The only two fields used for binding are `Path` and `X-Descriptors`.  **Path**
is a dot-delimited path of the field on the object that the descriptor
describes. The **X-Descriptors** defines the binding meta-data similar to CR/CRD
annotation.

If the path is pointing to a `Secret` resource, there should be an X-Descriptors defined like this:

    urn:alm:descriptor:io.kubernetes:Secret

Similary, if the path is pointing to a `ConfigMap` resource, there should be an
X-Descriptors defined like this:

    urn:alm:descriptor:io.kubernetes:ConfigMap

There should be a `service.binding` entry in the X-Descriptors to identify that
this is a Service Binding configuration.

If the `Secret` or `ConfigMap` specific X-Descriptors are not present, that
descriptor is referencing the value at the given path.

## Extract an entire Secret as the binding Secret

One of the common use case is to inject all the values from a Secret resource.
The Secret resource must be specified as an attribute in the custom resource.
If the attribute is part of `.spec`, you can create SpecDescriptor, and if it's
part of the `.status`, you can create StatusDescriptor.  In the descriptor, you
can use `path` attribute to point to field with the Secret resource name.

Here is an example configuration:

```
- path: data.dbCredentials
  x-descriptors:
  - urn:alm:descriptor:io.kubernetes:Secret
  - service.binding
```

The X-Descriptor has `urn:alm:descriptor:io.kubernetes:Secret` entry to indicate
the path is pointing to a Secret resource.

## Extract an entire ConfigMap as the binding Secret

Another common use case is to inject all the values from a ConfigMap resource.
The ConfigMap resource must be specified as an attribute in the custom resource.
If the attribute is part of `.spec`, you can create SpecDescriptor, and if it's
part of the `.status`, you can create StatusDescriptor.  In the descriptor, you
can use `path` attribute to point to field with the ConfigMap resource name.

Here is an example configuration:

```
- path: data.dbConfiguration
  x-descriptors:
  - urn:alm:descriptor:io.kubernetes:ConfigMap
  - service.binding
```

The X-Descriptor has `urn:alm:descriptor:io.kubernetes:ConfigMap` entry to
indicate the path is pointing to a ConfigMap resource.

## Extract an entry from a ConfigMap/Secret into the binding Secret

When you want to extract only a particular entry from a Secret or ConfigMap, the X-Descriptor can
update `service.binding` line with a name and `sourceKey`.  Here is an example:

```
- path: data.dbConfiguration
  x-descriptors:
  - urn:alm:descriptor:io.kubernetes:ConfigMap
  - service.binding:my_certificate:sourceKey=certificate
```

In the above example, `sourceKey` points to the name of the key in the Secret
resource, which is `certificate`.  And `my_certificate` is the name of the
binding key that's going to be injected.

## Extract a resource definition value into the binding Secret

When values required for binding to the backing service are available as
attributes of its resources, it's possible to annotate these values (which will
identify them as "binding metadata"), using an X-Descriptors with name.  Here is
an example:

```
- path: data.connectionURL
  x-descriptors:
  - service.binding:uri
```

In the above example, the `connectionURL` attribute points to the required
value.  It will be injected as `uri`.

## Extract the entries of a collection into the binding Secret selecting the key and value from each entry

Consider this example from a backig service resource:

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

If you want to inject all those values with key as `primary`, `secondary` etc.,
you can an X-Descriptors like this:

```
- path: bootstrap
  x-descriptors:
  - service.binding:endpoints:elementType=sliceOfMaps:sourceKey=type:sourceValue=url
```

## Extract the items of a collection into the binding Secret with one key per item

Consider this example from a backig service resource:

```
spec:
    tags:
      - knowledge
      - is
      - power
```

If you want to inject all those values with key as `prefix_0`, `prefix_1` etc.,
you can an X-Descriptors like this.  The default prefix is the name of the
resource kind:

```
- path: spec.tags
  x-descriptors:
  - service.binding:tags:elementType=sliceOfStrings
```

## Extract the values of collection entries into the binding Secret with one key per entry value

Consider this example:

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

If the structure is like this, and you want to inject all those values with key
as `prefix_0`, `prefix_1` etc., you can an X-Descriptors like this.  The default
prefix is the name of the resource kind:

```
- path: bootstrap
  x-descriptors:
  - service.binding:endpoints:elementType=sliceOfStrings:sourceValue=url
```
