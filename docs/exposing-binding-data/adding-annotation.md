---
sidebar_position: 4
---

# Adding Binding Metadata as Annotations

Many services, are not Provisioned Service-compliant.  These services are still
exposing the appropriate binding information, but not in the way that the
specification and Service Binding operator expect. As a result, you'll need to
manually alter the backing services' custom resources and CRDs by adding
annotations to create a corresponding mapping with the connectivity values (and
binding metadata).

The Service Binding will detect the annotations added to the CRDs and custom
resources.  Then the Service Binding will create a Secret with the values
extracted based on the annotations.  Finally the Service Binding will inject the
values into the application.

The annotations will need to be added under the `metadata` section to be
injected by Service Binding operator into an application.  A couple of example
are given below:

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

This is the referenced ConfigMap:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: db-config
data:
  db_timeout: "10s"
  username: "guest"
```

## Expose all Secret keys as binding data

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

This is the referenced Secret:

```
apiVersion: v1
kind: Secret
metadata:
  name: db-cred
data:
  password: "MTBz"
  username: "Z3Vlc3Q="
```

## Expose all ConfigMap keys as binding data

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
    dbConfiguration: db-config
```

This is the referenced ConfigMap:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: db-config
data:
  db_timeout: "10s"
  username: "guest"
```

## Expose an entry from a ConfigMap as binding data

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

This is the referenced ConfigMap:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: db-config
data:
  db_timeout: "10s"
  username: "guest"
```

The biding data should have a key with name as `timeout` and value as `10s`.

## Expose an entry from a Secret as binding data

```
apiVersion: apps.example.org/v1beta1
kind: Database
metadata:
  name: my-db
  annotations:
    "service.binding/timeout": "path={.status.data.dbConfiguration},objectType=Secret,sourceKey=db_timeout"
spec:
  ...

status:
  data:
    dbConfiguration: db-conf
```

This is the referenced Secret:

```
apiVersion: v1
kind: Secret
metadata:
  name: db-config
data:
  password: "MTBz"
  username: "Z3Vlc3Q="
```

The biding data should have a key with name as `timeout` and value as `10s`.

## Expose a resource definition value as binding data

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

## Expose the entries of a collection as binding data selecting the key and value from each entry

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

The binding data files should be like this:

```
/bindings/<binding-name>/uri_primary => primary.example.com
/bindings/<binding-name>/uri_secondary => secondary.example.com
/bindings/<binding-name>/uri_404 => black-hole.example.com
```

## Expose the items of a collection as binding data with one key per item

```
apiVersion: apps.example.org/v1beta1
kind: Database
metadata:
  name: my-db
  annotations:
    "service.binding/tags": "path={.spec.tags},elementType=sliceOfStrings"

spec:
    tags:
      - knowledge
      - is
      - power
```

The binding data files should be like this:

```
/bindings/<binding-name>/tags_0 => knowledge
/bindings/<binding-name>/tags_1 => is
/bindings/<binding-name>/tags_2 => power
```

## Expose the values of collection entries as binding data with one key per entry value

```
apiVersion: apps.example.org/v1beta1
kind: Database
metadata:
  name: my-db
  annotations:
    "service.binding/url": "path={.spec.connections},elementType=sliceOfStrings,sourceValue=url"

spec:
    connections:
      - type: primary
        url: primary.example.com
      - type: secondary
        url: secondary.example.com
      - type: '404'
        url: black-hole.example.com
```
The binding data files should be like this:

```
/bindings/<binding-name>/url_primary => primary.example.com
/bindings/<binding-name>/url_secondary => secondary.example.com
/bindings/<binding-name>/url_404 => black-hole.example.com
```
