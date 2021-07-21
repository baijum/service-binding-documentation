---
sidebar_position: 1
---

# Installing Service Binding

The Service Binding Operator can be installed on the following version of Kubernetes and OpenShift.

- Kubernetes version 1.20 or above.
- OpenShift version 4.7 or above.

## Installing Operator using OLM

You can install ServiceBinding from
[OperatorHub.io](https://operatorhub.io/operator/service-binding-operator).  To
see the installation steps, click on the blue _Install_ button.

## Installing Operator without OLM

If you don't have OLM, you can install the operator using the released configuration:

```
kubectl apply -f https://github.com/redhat-developer/service-binding-operator/releases/latest/download/release.yaml
```
