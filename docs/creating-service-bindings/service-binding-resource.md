---
sidebar_position: 6
---

# Service Binding Resource

_In this section, we would highlight the different options based on the specification_

https://github.com/k8s-service-bindings/spec#service-binding

This is the schema of `ServiceBinding` resource:

```
apiVersion: service.binding/v1alpha2
kind: ServiceBinding
metadata:
  name:                 # string
  generation:           # int64, defined by the Kubernetes control plane
  ...
spec:
  name:                 # string, optional, default: .metadata.name
  type:                 # string, optional
  provider:             # string, optional

  application:          # ObjectReference-like
    apiVersion:         # string
    kind:               # string
    name:               # string, mutually exclusive with selector
    selector:           # metav1.LabelSelector, mutually exclusive with name
    containers:         # []string, optional

  service:              # Provisioned Service resource ObjectReference-like
    apiVersion:         # string
    kind:               # string
    name:               # string

  env:                  # []EnvMapping, optional
  - name:               # string
    key:                # string

status:
  binding:              # LocalObjectReference, optional
    name:               # string
  conditions:           # []metav1.Condition containing at least one entry for `Ready`
  observedGeneration:   # int64
```

The `.spec.name` is an optional field of type string.  It can be used to
override the `.metadata.name` value.  The `.spec.name` value is used as binding
name.  In the below example projected bindings, `account-database` and
`transaction-event-stream` are two binding names:

```
$SERVICE_BINDING_ROOT
├── account-database
│   ├── type
│   ├── provider
│   ├── uri
│   ├── username
│   └── password
└── transaction-event-stream
    ├── type
    ├── connection-count
    ├── uri
    ├── certificates
    └── private-key
```

The `.spec.type` and `.spec.provider` values are added into the binding Secret
resource.  Both fields are optional, if present, it will override value in the
Provisioned Service Secret resource.  The chapter on "Using Injected Bindings"
has information about how to use these values to locate the bindings using the
language specific libraries.

The `.spec.application` and `.spec.service` is already explained in the
`Creating Service Binding` chapter.

The `.spec.env` going to create environment variables in the application.  It is
a list of environment name and Secret keys.  The name is the environment
variable name, normally fully capitalized.  The key is any data key in
Provisioned Service Secret resource.

The status details will be updated by the operator with a binding name,
conditions, and observedGeneration.
