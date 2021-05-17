---
sidebar_position: 5
---

# Unbind Application

To unbind an application from a service, delete the `ServiceBinding` custom resource linked to it:

```
kubectl delete ServiceBinding binding-request
```