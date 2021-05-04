---
sidebar_position: 4
---

# Binding with non-podSpec-based application 

<kbd>TBU</kbd>

If your application is to be deployed as a non-podSPec-based workload such that the containers path should bind at a custom location, the `ServiceBinding` API provides an API to achieve that.


``` yaml
apiVersion: binding.operators.coreos.com/v1alpha1
kind: ServiceBinding
metadata:
  name: binding-request
  namespace: service-binding-demo
spec:
    application:
        resourceRef: example-appconfig
        group: stable.example.com
        version: v1
        resource: appconfigs
        bindingPath:
            secretPath: spec.secret # custom path to secret reference
            containersPath: spec.containers # custom path to containers reference
    ...
    ...
```



