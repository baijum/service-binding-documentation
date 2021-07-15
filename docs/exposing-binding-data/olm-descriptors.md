---
sidebar_position: 5
---

# Adding Binding Metadata as OLM Descriptors

The secret generation behavior explained in the annotations is applicable for
OLM descriptors also.  The data model is also same as that of annotations, but
the syntax is changed to match OLM descriptors naming pattern.

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
