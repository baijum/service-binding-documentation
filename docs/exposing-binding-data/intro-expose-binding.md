---
sidebar_position: 1
---

# Introduction

Service Binding operator supports exposing binding data in these ways:

1. Provisioned Service
2. Direct Secret Reference
3. Secret Generated  through CRD/CR annotations
4. Secret Generated through OLM Descriptors
5. Detect Bindings through owned resources

The following sections explain each of these topics.

[Provisioned Service][provisioned-service] is useful for backing service authors
to provide all the values required for connectivity.

[Direct Secret Reference][direct-secret-reference] allows application developers
to connect to a service by using Secret as a reference.  This is useful when
there is no Provisioned Service available and you have a all the values required
for connectivity available in a Secret resource.

Secret Generated through CRD/CR annotations can be used by the application
developers when the values are are available in backing service resources.

Secret Generated through OLM descriptors can be used by the application
developers when the values are are available in backing service resources.

Detect Bindings through owned resources can be used by the application
developers when the values can be detected based on ownership from backing
service resources.

[provisioned-service]: https://github.com/k8s-service-bindings/spec#provisioned-service
[direct-secret-reference]: https://github.com/k8s-service-bindings/spec#direct-secret-reference
