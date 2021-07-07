---
sidebar_position: 1
---

# Installing Service Binding

## Installing Operator Lifecycle Manager (OLM)

To install [Operator Lifecycle Manager][olm], run this command:

```
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.18.2/install.sh | bash -s v0.18.2
```

Alternately, if you have have [Operator SDK][operator-sdk] installed, run this
command:

```
operator-sdk olm install --version=v0.18.2
```

## Service Binding Installation

You can install ServiceBinding from
[OperatorHub.io](https://operatorhub.io/operator/service-binding-operator).  To
see the installation steps, click on the blue _Install_ button.

To install the ServiceBinding operator:

```
kubectl create -f https://operatorhub.io/install/service-binding-operator.yaml
```

This Operator will be installed in the `operators` namespace and will be usable
from all namespaces in the cluster.

After install, watch your operator come up using this command:

```
kubectl get csv -n operators
```

Wait until you see a message something like this:

```
NAME                              DISPLAY                    VERSION   REPLACES                          PHASE
service-binding-operator.v0.8.0   Service Binding Operator   0.8.0     service-binding-operator.v0.7.1   Succeeded
```

## Compatiblity Note

## Operator

_How can To be provided soon_

## Helm

_To be provided soon_

[olm]: https://olm.operatorframework.io
[operator-sdk]: https://sdk.operatorframework.io
