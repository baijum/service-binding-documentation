---
sidebar_position: 5
---

# Adding Binding Metadata as OLM Descriptors

If your operator is distributed as an [Operator
Bundle](https://github.com/operator-framework/operator-registry/blob/master/docs/design/operator-bundle.md),
you can add OLM descriptors to expose the binding data.  The OLM descriptors are
part of [Cluster Service
Version](https://docs.openshift.com/container-platform/4.7/operators/operator_sdk/osdk-generating-csvs.html)
files.  To expose the binding data, you can use SpecDescriptors and
StatusDescriptors.  To specify a path under the `.spec` of a custom resource,
use SpecDescriptors.  Similarly, to specify a path under `.status` of a custom
resource, use StatusDescriptors.

The secret generation behavior explained in the annotations is applicable for
OLM descriptors also.  The data model is also same as that of annotations, but
the syntax is different to match OLM descriptors naming pattern.

The only two fields that is used for binding is `Path` and `X-Descriptors`.
Path is a dot-delimited path of the field on the object that the descriptor
describes. The X-Descriptors define the binding meta-data similar to CR/CRD
annotation.

If the path is pointing to a `Secret` resource, there should be an X-Descriptors like this:

    urn:alm:descriptor:io.kubernetes:Secret

Similary, if the path is pointing to a `ConfigMap` resource, there should be an X-Descriptors like this:

    urn:alm:descriptor:io.kubernetes:ConfigMap

If the `Secret` or `ConfigMap` specific X-Descriptors are not present, that
descriptor should be accessing multiple values at the given path.

## Mount an entire Secret as the binding Secret

```
- path: data.dbCredentials
  x-descriptors:
  - urn:alm:descriptor:io.kubernetes:Secret
  - service.binding
```

## Mount an entire ConfigMap as the binding Secret

```
- path: data.dbConfiguration
  x-descriptors:
  - urn:alm:descriptor:io.kubernetes:ConfigMap
  - service.binding
```

## Mount an entry from a ConfigMap/Secret into the binding Secret

```
- path: data.dbConfiguration
  x-descriptors:
  - urn:alm:descriptor:io.kubernetes:ConfigMap
  - service.binding:certificate:sourceKey=certificate
```

## Mount a resource definition value into the binding Secret


```
- path: data.connectionURL
  x-descriptors:
  - service.binding:uri
```

## Mount the entries of a collection into the binding Secret selecting the key and value from each entry

```
- path: bootstrap
  x-descriptors:
  - service.binding:endpoints:elementType=sliceOfMaps:sourceKey=type:sourceValue=url
```

## Mount the items of a collection into the binding Secret with one key per item

```
- path: spec.tags
  x-descriptors:
  - service.binding:tags:elementType=sliceOfStrings
```

## Mount the values of collection entries into the binding Secret with one key per entry value

```
- path: bootstrap
  x-descriptors:
  - service.binding:endpoints:elementType=sliceOfStrings:sourceValue=url
```
