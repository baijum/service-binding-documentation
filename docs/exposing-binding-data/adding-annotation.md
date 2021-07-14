---
sidebar_position: 4
---

# Adding Binding Metadata as Annotations

Many services, especially initially, will not be Provisioned Service-compliant.
These services will expose the appropriate binding information, but not in the
way that the specification or applications expect.  Users should have a way of
describing a mapping from existing data associated with arbitrary resources and
CRDs to a representation of a binding Secret.

To handle the majority of existing resources and CRDs, Secret generation needs
to support the following behaviors:

1. Extract a string from a resource
2. Extract an entire ConfigMap/Secret refrenced from a resource
3. Extract a specific entry in a ConfigMap/Secret referenced from a resource
4. Extract entries from a collection of objects, mapping keys and values from entries in a ConfigMap/Secret referenced from a resource
5. Extract a collection of specific entry values in a resource's collection of objects
6. Map each value to a specific key
7. Map each value of a collection to a key with generated name

## Data Model

* `path`: A template representation of the path to the element in the Kubernetes resource. The value of path could be specified in either JSONPath or GO templates
* `elementType`: Specifies if the value of the element referenced in `path` is of type `string` / `sliceOfStrings` / `sliceOfMaps`. Defaults to `string` if omitted.

* `objectType`: Specifies if the value of the element indicated in `path` refers to a `ConfigMap`, `Secret` or a plain string in the current namespace!  Defaults to `Secret` if omitted and `elementType` is a non-`string`.

* `sourceKey`: Specifies the key in the configmap/Secret that is be added to the binding Secret. When used in conjunction with `elementType`=`sliceOfMaps`, `sourceKey` specifies the key in the slice of maps whose value would be used as a key in the binding Secret. This optional field is the operator author intends to express that only when a specific field in the referenced `Secret`/`ConfigMap` is bindable.

* `sourceValue`: Specifies the key in the slice of maps whose value would be used as the value, corresponding to the value of the `sourceKey` which is added as the key, in the binding Secret. Mandatory only if `elementType` is `sliceOfMaps`.


One of the way to expose binding data to 

## Mount an entire Secret as the binding Secret

```
apiVersion: apps.example.org/v1beta1
kind: Database
metadata:
  name: my-db
  annotations:
    "service.binding": "path={.status.data.dbCredentials},objectType=Secret"
spec:
  ...
  
status:
  data:
    dbCredentials: db-cred
```

## Mount an entire ConfigMap as the binding Secret

```
apiVersion: apps.example.org/v1beta1
kind: Database
metadata:
  name: my-db
  annotations:
    "service.binding": "path={.status.data.dbConfiguration},objectType=ConfigMap"
spec:
  ...
  
status:
  data:
    dbConfiguration: db-conf
```

## Mount an entry from a ConfigMap/Secret into the binding Secret

```
apiVersion: apps.example.org/v1beta1
kind: Database
metadata:
  name: my-db
  annotations:
    "service.binding/timeout": "path={.status.data.dbConfiguration},objectType=ConfigMap,sourceKey=db_timeout"
spec:
  ...
  
status:
  data:
    dbConfiguration: db-conf
```

The same annotation should work for Secret resources also.

## Mount a resource definition value into the binding Secret

```
apiVersion: apps.example.org/v1beta1
kind: Database
metadata:
  name: my-db
  annotations:
    "service.binding/uri":  "path={.status.data.connectionURL}"
spec:
  ...
  
status:
  data:
    connectionURL: "http://guest:secret123@192.168.1.29/db"
```

## Mount the entries of a collection into the binding Secret selecting the key and value from each entry

```
apiVersion: apps.example.org/v1beta1
kind: Database
metadata:
  name: my-db
  annotations:
    "service.binding/uri": "path={.status.connections},elementType=sliceOfMaps,sourceKey=type,sourceValue=url"
spec:
  ...
  
status:
  connections:
    - type: primary
      url: primary.example.com
    - type: secondary
      url: secondary.example.com
    - type: '404'
      url: black-hole.example.com
```

## Mount the items of a collection into the binding Secret with one key per item

                annotations:
                    service.binding/tags: path={.spec.tags},elementType=sliceOfStrings

            spec:
                tags:
                  - knowledge
                  - is
                  - power


## Mount the values of collection entries into the binding Secret with one key per entry value

                annotations:
                    service.binding/url: path={.spec.connections},elementType=sliceOfStrings,sourceValue=url

            spec:
                connections:
                  - type: primary
                    url: primary.example.com
                  - type: secondary
                    url: secondary.example.com
                  - type: '404'
                    url: black-hole.example.com
