---
sidebar_position: 4
---

# Adding Binding Metadata as Annotations

If your backing service is not compliant with the Service Binding specification
as a Provisioned Service resource, you can annotate the resources of the backing
service to expose the binding metadata with specific annotations.  Adding
annotations under the metadata section alters the custom resources and CRDs of
the backing services.  Using this method, you can create a corresponding mapping
with the connectivity values and binding metadata.

The Service Binding Operator detects the annotations added to the CRDs and
custom resources and creates a Secret service resource with the values extracted
based on the annotations.  The Service Binding Operator then injects these
values into the application.

The following examples show the annotations that are added under the metadata
section and a referenced ConfigMap object from a resource:

## Example: Annotations for a Secret object

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

## Example: Annotations for a ConfigMap object

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

## Example: Referenced ConfigMap object from a resource

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: db-config
data:
  db_timeout: "10s"
  username: "guest"
```

## Exposing an entire Secret as the binding metadata

Add the required annotations for the Secret, under the metadata section.

### Example 

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

### Example: The referenced Secret from the backing service resource

```
apiVersion: v1
kind: Secret
metadata:
  name: db-cred
data:
  password: "MTBz"
  username: "Z3Vlc3Q="
```

## Exposing an entire config map as the binding metadata

Add the required annotations for the ConfigMap, under the metadata section.

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

### Example: The referenced ConfigMap from the backing service resource

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: db-config
data:
  db_timeout: "10s"
  username: "guest"
```

## Exposing an entry from a ConfigMap as the binding metadata

Add the required annotations for the ConfigMap entry, under the `metadata` section.

### Example

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

### Example: The Referenced config map from the backing service resource

The binding metadata should have a key with name as `timeout` and value as `10s`:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: db-config
data:
  db_timeout: "10s"
  username: "guest"
```

## Exposing an entry from a Secret as the binding metadata

Adding the required annotations under the `metadata` section.

### Example

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

### Example: The referenced Secret from the backing service resource

The binding metadata should have a key with name as `timeout` and value as `10s`:

```
apiVersion: v1
kind: Secret
metadata:
  name: db-config
data:
  password: "MTBz"
  username: "Z3Vlc3Q="
```

## Exposing a resource definition value as the binding metadata

Add the required annotations under the `metadata` section.

### Example

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

## Exposing the entries of a collection as the binding metadata by selecting the key and value from each entry

Add the required annotations under the `metadata` section.

### Example

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

### Example: Binding metadata files

```
/bindings/<binding-name>/uri_primary => primary.example.com
/bindings/<binding-name>/uri_secondary => secondary.example.com
/bindings/<binding-name>/uri_404 => black-hole.example.com
```

## Exposing the items of a collection as the binding metadata with one key per item

Add the required annotations under the `metadata` section.

### Example

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

### Example: Binding metadata files

```
/bindings/<binding-name>/tags_0 => knowledge
/bindings/<binding-name>/tags_1 => is
/bindings/<binding-name>/tags_2 => power
```

## Exposing the values of collection entries as the binding metadata with one key per entry value

Add the required annotations under the `metadata` section.

### Example

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

### Example: Binding metadata files

```
/bindings/<binding-name>/url_primary => primary.example.com
/bindings/<binding-name>/url_secondary => secondary.example.com
/bindings/<binding-name>/url_404 => black-hole.example.com
```
