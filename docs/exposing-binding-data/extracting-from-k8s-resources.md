---
sidebar_position: 3
---

# Extracting Binding Metadata from Kubernetes Resource

## Extract a string from a Kubernetes resource

_List of use cases:_

_Provide Sample_

_Annotation + descriptor_ 


## Extract a string from the Kubernetes resource, and map it to custom name in the binding Secret

_List of use cases:_

_Provide Sample_

_Annotation + descriptor_ 

## Extract an entire configmap/Secret from the Kubernetes resource

_List of use cases:_

_Provide Sample_

_Annotation + descriptor_ 

## Extract a specific field from the configmap/Secret from the Kubernetes resource, and bind it as an environment variable

_List of use cases:_

_Provide Sample_

_Annotation + descriptor_ 

## Extract a specific field from the configmap/Secret from the Kubernetes resource and and bind it as a volume mount

_List of use cases:_

_Provide Sample_

_Annotation + descriptor_ 

## Extract a specific field from the configmap/Secret from the Kubernetes resource and map it to different name in the binding Secret

_List of use cases:_

_Provide Sample_

## Extract a “slice of maps” from the Kubernetes resource and generate multiple fields in the binding Secret

_List of use cases:_

_Provide Sample_

_Annotation + descriptor_ 


## Extract a “slice of strings” from a Kubernetes resource and indicate the content in a specific index in the slice to be relevant for binding

_Provide Sample_

_List of use cases:_

_Annotation + descriptor_ 

## Extract binding information from the Kubernetes resource using Go templates and generate multiple fields in the binding Secret <kbd>EXPERIMENTAL</kbd>

Requirement: *Extract binding information from the Kubernetes resource using Go templates and generate multiple fields in the binding Secret.*

A sample Kafka CR:

```yaml
    apiVersion: kafka.strimzi.io/v1alpha1
    kind: Kafka
    metadata:
      name: my-cluster
    ...
    status:
      listeners:
        - type: plain
          addresses:
            - host: my-cluster-kafka-bootstrap.service-binding-demo.svc
              port: 9092
            - host: my-cluster-kafka-bootstrap.service-binding-demo.svc
              port: 9093
        - type: tls
          addresses:
            - host: my-cluster-kafka-bootstrap.service-binding-demo.svc
              port: 9094
```

Go Template:
```
    {{- range $idx1, $lis := .status.listeners -}}
      {{- range $idx2, $adr := $el1.addresses -}}
        {{ $lis.type }}_{{ $idx2 }}={{ printf "%s:%s\n" "$adr.host" "$adr.port" | b64enc | quote }}
      {{- end -}}
    {{- end -}}
```

The above Go template produces the following string when executed on the sample Kafka CR:

```
    plain_0="<base64 encoding of my-cluster-kafka-bootstrap.service-binding-demo.svc:9092>"
    plain_1="<base64 encoding of my-cluster-kafka-bootstrap.service-binding-demo.svc:9093>"
    tls_0="<base64 encoding of my-cluster-kafka-bootstrap.service-binding-demo.svc:9094>"
```

The string can then be parsed into key-value pairs to be added into the final binding secret. The Go template above can be written as one-liner and added as `{{GO TEMPLATE}}` in the annotation and descriptor below.

Annotation

```
    “service.binding:
    "path={.status.listeners},elementType=template,source={{GO TEMPLATE}}"
    ```

    Descriptor

    ```
    - path: listeners
      x-descriptors:
        - service.binding:elementType=template:source={{GO TEMPLATE}}
```

