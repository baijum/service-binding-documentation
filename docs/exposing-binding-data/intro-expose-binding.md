---
sidebar_position: 1
---

# Introduction

Connecting applications to backing services is always a challenge as each service provider is suggesting a different way to access their secrets and consume it in an application. 
Service Binding helps the developers by providing a consistent and predictable experience and removes error-prone usual manual steps to configure the binding between an application and backing services. 

In order for Service Binding operator to provide the binding information, those needs to be exposed by the backing services in a way that can be detect by Service Binding. There are basically two main scenarios:

* **The backing service is considered a [Provisioned Service][provisioned-service]**: that means that the service you are looking to connect to, is compliant to the Service Binding specification and the all the binding values will be detected automatically.

* **The backing service is not a [Provisioned Service][provisioned-service]**: this means that you'll need to expose the binding metadata from the backing service. In this case there are various ways to do that: 
  * **[Direct Secret Reference][direct-secret-reference]**: when all the required binding values are available in a secret, you can refenrence it in your Service Binding definition.
  * **Secret Generated through CRD/CR annotations**: when you can annotate the resources of the backing service, so that it exposes the binding metadata with specific annotations.
  * **Secret Generated through OLM Descriptors**: when you can provide OLM descriptors, if the backing service is provided by an Operator. 
  * **Detect Bindings through owned resources**: when the backing service own kubernetes resources (Services, Routes, ConfigMaps or Secrets) that can be used to look-up for the binding metadatas.



[provisioned-service]: https://github.com/k8s-service-bindings/spec#provisioned-service
[direct-secret-reference]: https://github.com/k8s-service-bindings/spec#direct-secret-reference
