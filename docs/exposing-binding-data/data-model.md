---
sidebar_position: 2
---

# Data Model

* `path`: A template representation of the path to the element in the Kubernetes resource. The value of path could be specified in either JSONPath or GO templates
* `elementType`: Specifies if the value of the element referenced in `path` is of type `string` / `sliceOfStrings` / `sliceOfMaps`. Defaults to `string` if omitted.

* `objectType`: Specifies if the value of the element indicated in `path` refers to a `ConfigMap`, `Secret` or a plain string in the current namespace!  Defaults to `Secret` if omitted and `elementType` is a non-`string`.

* `bindAs`: Specifies if the element is to be bound as an environment variable or a volume mount using the keywords `envVar` and `volume`, respectively. Defaults to `envVar` if omitted.

* `sourceKey`: Specifies the key in the configmap/Secret that is be added to the binding Secret. When used in conjunction with `elementType`=`sliceOfMaps`, `sourceKey` specifies the key in the slice of maps whose value would be used as a key in the binding Secret. This optional field is the operator author intends to express that only when a specific field in the referenced `Secret`/`ConfigMap` is bindable.

* `sourceValue`: Specifies the key in the slice of maps whose value would be used as the value, corresponding to the value of the `sourceKey` which is added as the key, in the binding Secret. Mandatory only if `elementType` is `sliceOfMaps`.