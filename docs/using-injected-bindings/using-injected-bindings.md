---
sidebar_position: 1
---

# General Concept

When using the Service Binding operator, a set of binding metadata are projected
into your application using the following methods:

- By default, as files.
- As environment variables, if the value for the `.spec.bindAsFiles` parameter
  is set to `false` in the `ServiceBinding` resource.

## Understanding the consumption of binding metadata

The primary mechanism of projection is through files mounted at a specific
directory.  The bindings directory path can be discovered through
`SERVICE_BINDING_ROOT` environment variable setup in your application.

Within this service binding root directory, there can be multiple bindings
projected from different Service Bindings.  For example, if an application
requires to connect to a database and cache server.  In that case, one Service
Binding can provide the database, and the other Service Binding can provide
bindings to the cache server.

Let's take a look at the example:

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

In the previous example, there are two bindings under the `SERVICE_BINDING_ROOT`
directory.  The `account-database` and `transaction-event-stream` are the names
of the bindings.  Files within each bindings directory has a special file named
`type`, and you can rely on the value of that file to identify the type of the
binding projected into that directory.  In certain directories, you can also see
another file named `provider`.  The provider is an additional identifier to
narrow down the type further.  Retrieving the bindings through the bindings
directory name is not a good practice -- it makes your application less
portable.  Always use the `type` field and, if necessary, `provider` to look up
the bindings.

The Service Binding Operators uses `ServiceBinding` resource name
(`.metadata.name`) as the bindings directory name, but the spec also provides a
way to override that name through the `.spec.name` field. So, there is a chance
for bindings name collision.  However, due to the nature of the volume mount in
Kubernetes, the bindings directory will contain values from only one of the
Secret resources.  This is a caveat of using the bindings directory name to look
up the bindings.

## Using Binding metadata injected as files

For determining the folder where bindings are injected, you can check the
`.spec.mountPath` value from the `ServiceBinding` resource which specifies the
destination used for the injection.

Alternatively, you can also check `SERVICE_BINDING_ROOT` environment variable in
the application resource.  If both are set then the `SERVICE_BINDING_ROOT`
environment variable takes the higher precedence.

### Table: Summary of the final path computation

The following table summarizes how the final bind path is computed:

| .spec.mountPath | SERVICE_BINDING_ROOT  | Final Path                            |
| --------------- | --------------------- | --------------------------------------|
| nil             | non-existent          | /bindings/ServiceBinding_Name         |
| nil             | /some/path/root       | /some/path/root/<ServiceBinding_Name> |
| /home/foo       | non-existent          | /home/foo                             |
| /home/foo       | /some/path/root       | /some/path/root/<ServiceBinding_Name> |

You can use the built-in language feature of your programming language of choice
to read environment variables.

For accessing bindings within `SERVICE_BINDING_ROOT`, there are language or
framework specific programs:

1. Python: https://github.com/baijum/pyservicebinding
2. Go: https://github.com/baijum/servicebinding
3. Java/Spring: https://github.com/spring-cloud/spring-cloud-bindings
4. Quarkus: https://quarkus.io/guides/deploying-to-kubernetes#service-binding
5. JS/Node: https://github.com/nodeshift/kube-service-bindings

Note: All these libraries expect `SERVICE_BINDING_ROOT` to be set.

### Example: Python client usage

```
from pyservicebinding import binding
try:
    sb = binding.ServiceBinding()
except binding.ServiceBindingRootMissingError as msg:
    # log the error message and retry/exit
    print("SERVICE_BINDING_ROOT env var not set")

sb = binding.ServiceBinding()

bindings_list = sb.bindings("postgresql")
```

In the previous example, the `bindings_list` parameter contains the binding
metadata for the `postgresql` type.  For full API, see the
[documentation](https://github.com/baijum/pyservicebinding).

### Environment Variables

The spec also has support for projecting environment variables.  You can use the
built-in language feature of your programming language of choice to read
environment variables.  The container must restart to update the values of
environment variables if there is a change in the Secret resource.

Here is example Python client usage:

```
import os

username = os.getenv("USERNAME")
password = os.getenv("PASSWORD")
```
