---
sidebar_position: 1
---

# Using Injected Bindings

The bindings could injected as files or enviroment variables. By default
bindings are injected as files.  To inject enviroment variable, set
`.spec.bindAsFiles` value to `false`.

For determining the folder where bindings should be injected, youo can specify
the destination using `.spec.mountPath` or you can use `SERVICE_BINDING_ROOT`
environment variable.  If both are set then the `SERVICE_BINDING_ROOT`
environment variable takes the higher precedence.

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

Note: All these libraries expect `SERVICE_BINDING_ROOT` set.

