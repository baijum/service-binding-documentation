---
sidebar_position: 3
---

# Custom Path Injection

## Containers Path

This feature is only available for `ServiceBinding` in the
`binding.operators.coreos.com` API group.

If your application is using a custom resource and containers path should bind
at a custom location, SBO provides an API to achieve that.  Here is an example
custom resource with containers in a custom location:

```
apiVersion: "stable.example.com/v1"
kind: AppConfig
metadata:
    name: example-appconfig
spec:
    containers:
    - name: hello-world
      image: yusufkaratoprak/kubernetes-gosample:latest
      ports:
      - containerPort: 8090
```

In the above CR, the containers path is at `spec.containers`.  You can specify
this path in the `ServiceBinding` config at
`spec.application.bindingPath.containersPath`:

```
apiVersion: binding.operators.coreos.com/v1alpha1
kind: ServiceBinding
metadata:
    name: binding-request
spec:
    namePrefix: qiye111
    application:
        name: example-appconfig
        group: stable.example.com
        version: v1
        resource: appconfigs
        bindingPath:
            containersPath: spec.containers
    services:
      - group: postgresql.baiju.dev
        version: v1alpha1
        kind: Database
        name: example-db
        id: zzz
        namePrefix: qiye
```

After reconciliation, the `spec.containers` is going to be updated with
`envFrom` and `secretRef` like this:

```
apiVersion: stable.example.com/v1
kind: AppConfig
metadata:
    name: example-appconfig
spec:
  containers:
  - env:
    - name: ServiceBindingOperatorChangeTriggerEnvVar
      value: "31793"
    envFrom:
    - secretRef:
        name: binding-request
    image: yusufkaratoprak/kubernetes-gosample:latest
    name: hello-world
    ports:
    - containerPort: 8090
    resources: {}
```

## Secret Path

This feature is only available for `ServiceBinding` in the
`binding.operators.coreos.com` API group.

If your application is using a custom resource and secret path should bind at a
custom location, SBO provides an API to achieve that.  Here is an example CR
with secret in a custom location:

```
apiVersion: "stable.example.com/v1"
kind: AppConfig
metadata:
    name: example-appconfig
spec:
    secret: some-value-72ddc0c540ab3a290e138726940591debf14c581
```

In the above CR, the secret path is at `spec.secret`.  You can specify
this path in the `ServiceBinding` config at
`spec.application.bindingPath.secretPath`:


```
apiVersion: binding.operators.coreos.com/v1alpha1
kind: ServiceBinding
metadata:
    name: binding-request
spec:
    namePrefix: qiye111
    application:
        name: example-appconfig
        group: stable.example.com
        version: v1
        resource: appconfigs
        bindingPath:
            secretPath: spec.secret
    services:
      - group: postgresql.baiju.dev
        version: v1alpha1
        kind: Database
        name: example-db
        id: zzz
        namePrefix: qiye
```

After reconciliation, the `spec.secret` is going to be updated with
`binding-request` as the value:

```
apiVersion: "stable.example.com/v1"
kind: AppConfig
metadata:
    name: example-appconfig
spec:
    secret: binding-request-72ddc0c540ab3a290e138726940591debf14c581
```
