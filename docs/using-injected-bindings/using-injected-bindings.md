---
sidebar_position: 1
---

# General Concept

When using Service Binding operator, you'll get a set of binding metadatas injected into your application.
That injection can be done in two different ways:
- As files: this is the default behavior,
- As environment variables: if
`.spec.bindAsFiles` is set to `false` in the  resource.

## Consuming the Bindings from Applications

The Application Projection section of the spec describes how the bindings are
projected into the application.  The primary mechanism of projection is through
files mounted at a specific directory.  The bindings directory path can be
discovered through `SERVICE_BINDING_ROOT` environment variable setup in your application.  
The operator must have injected `SERVICE_BINDING_ROOT` environment to all the containers
where bindings are created.

Within this service binding root directory, there could be multiple bindings
projected from different Service Bindings.  For example, suppose an application
requires to connect to a database and cache server. In that case, one Service
Binding can provide the database, and the other Service Binding can offer
bindings to the cache server.

Let's take a look at the example given in the spec:

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

In the above example, there are two bindings under the `SERVICE_BINDING_ROOT`
directory.  The `account-database` and `transaction-event-system` are the names
of the bindings.  Files within each bindings directory has a special file named
`type`, and you can rely on the value of that file to identify the type of the
binding projected into that directory.  In certain directories, you can also see
another file named `provider`.  The provider is an additional identifier to
narrow down the type further.  Retrieving the bindings through the bindings
directory name is not a practice -- it makes your application less portable.
Always use the `type` field and, if necessary, `provider` to look up the
bindings.

Usually, operators use `ServiceBinding` resource name (`.metadata.name`) as the
bindings directory name, but the spec also provides a way to override that name
through the `.spec.name` field. So, there is a chance for bindings name
collision.  However, due to the nature of the volume mount in Kubernetes, the
bindings directory will contain values from only one of the Secret resources.
This is a caveat of using the bindings directory name to look up the bindings.

### Purpose of the type and the provider fields in the application projection

Service Binding specification mandates `type` field and recommends `provider`
field in the binding Secret resource.  Normally `type` field should be good
enough to look up the bindings.  The provider field could be used where there
are different providers for the same Provisioned Service type.  For example, if
the type is `mysql`, the provider value could be `mariadb`, `oracle`, `bitnami`,
`aws-rds`, etc.  When the application is reading the binding values, if
necessary, the application could consider `type` and `provider` as a composite
key to avoid ambiguity.  It will be helpful if an application needs to choose a
particular provider based on the deployment environment.  In the deployment
environment (`stage`, `prod`, etc.), at any given time, you need to ensure only
one bindings projection exits for a given `type` or `type` & `provider` --
unless your application needs to connect to all the services.

## Using Binding injected as files

For determining the folder where bindings are injected, you can check the 
`.spec.mountPath` value from the `ServiceBinding` resource which specifies the destination used for the injection.

Alternatively, you can also use `SERVICE_BINDING_ROOT` environment variable in the application resource.  
If both are set then the
`SERVICE_BINDING_ROOT` environment variable takes the higher precedence.

The following table summarizes how the final bind path is computed:

| .spec.mountPath | SERVICE_BINDING_ROOT  | Final Bind Path                      |
| --------------- | --------------------- | ------------------------------------ |
| nil             | non-existent          | /bindings/ServiceBinding_Name        |
| nil             | /some/path/root       | /some/path/root/ServiceBinding_Name  |
| /home/foo       | non-existent          | /home/foo                            |
| /home/foo       | /some/path/root       | /some/path/root/ServiceBinding_Name  |

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

Here is example Python client usage:

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

In the above example, the `bindings_list` contains bindings for `postgresql`
type.  For full API, see the
[documentation](https://github.com/baijum/pyservicebinding).


### Programming language specific library APIs

The application can retrieve the bindings through the library available for your
programming language of choice.  The language-specific APIs are encouraged to
follow the pattern described here.  This is not an exhaustive list of APIs.
Consult your library API documentation to confirm the behavior.

The language binding API can create separate functions to retrieve bindings. For
example, in Go:

```
Bindings(_type string) []map[string]string
BindingsWithProvider(_type, provider string) []map[string]string
```

Languages with function overloading can use a method with different parameters
to retrieve bindings. For example, in Java:

```
public List<Binding> filterBindings(@Nullable String type)
public List<Binding> filterBindings(@Nullable String type, @Nullable String provider)
```

(Example taken from [Spring Cloud
Bindings](https://github.com/spring-cloud/spring-cloud-bindings))

Since the APIs are returning more than one value, depending on your application
need, you can choose to connect to the first entry or all of them, if required.

### Environment Variables

The spec also has support for projecting environment variables.  You can use the
built-in language feature of your programming language of choice to read
environment variables.  The container must restart to update the values of
environment variables if there is a change in the Secret resource.
