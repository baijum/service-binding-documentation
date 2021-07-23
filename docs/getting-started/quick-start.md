---
sidebar_position: 2
---

# Quick Start

In this quick start, you will see a sample application that you can deploy and
use to play around.  As part of this exercise, a backing service and an
application is required.  The backing service is a PostgreSQL database and
application is a [Spring Boot REST API server][petclinic].

Here is a schematic diagram of this setup:

![postgresql-spring-boot](/img/docs/postgresql-spring-boot.png)

The service binding operator will collect backing service configuration required
for connectivity and expose it to the applications.  If service binding operator
is not present, the applications admin should extract all the configuration
details and create a Secret resource and expose it to the application through
volume mount in Kubernetes.

## Prerequisites

Ensure you have installed and configured these:

- Kubernetes cluster (Use [minikube](https://minikube.sigs.k8s.io/) or
  [kind](https://kind.sigs.k8s.io/) locally)
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [Service Binding Operator](installing-service-binding).

## Database Backend

The application is going to connect to a PostgreSQL database backend.  The
PostgreSQL can be setup using the [Crunchy PostgreSQL operator from
OperatorHub.io][crunchy].

The installation of the operator doesn't create a database instance for
connection.  To create a database instance, you need to create custom resource
(`Pgcluster`) and that will trigger the operator reconciliation.  For
convenience, run this command to create `Pgcluster` custom resource:

```bash
kubectl apply -f https://gist.github.com/baijum/b99cd8e542868a00b2b5efc2e1b7dc10/raw/04eb5fe3d7f393af5a6760b03d9a1a3f5c725077/pgcluster.yaml
```

Ensure all the pods in `petclinic-demo` is running (it will take few minutes):

```bash
kubectl get pod -n petclinic-demo
```

You should see output something like this:

```
NAME                                          READY   STATUS    RESTARTS   AGE
backrest-backup-hippo-9gtqf                   1/1     Running   0          13s
hippo-597dd64d66-4ztww                        1/1     Running   0          3m33s
hippo-backrest-shared-repo-66ddc6cf77-sjgqp   1/1     Running   0          4m27s
```

The database will be empty by default, it requires the schema and sample data to
work with the application.  Now you can initialize the database with the schema
and sample data using this command:

```bash
bash <(curl -s https://gist.github.com/baijum/b99cd8e542868a00b2b5efc2e1b7dc10/raw/04eb5fe3d7f393af5a6760b03d9a1a3f5c725077/init-database.sh)>
```

Now the database is ready to connect from application.  The next section
explains how to configure application:

## Application Deployment

Now you can deploy the `spring-petclinic-rest` app with this `Deployment`
configuration:

```bash
kubectl apply -f https://gist.github.com/baijum/b99cd8e542868a00b2b5efc2e1b7dc10/raw/04eb5fe3d7f393af5a6760b03d9a1a3f5c725077/app-deployment.yaml
```

You can port-forward the application port and try to access it from your local system

```
kubectl port-forward --address 0.0.0.0 svc/spring-petclinic-rest 9966:80 -n petclinic-demo
```

You can open [http://localhost:9966/petclinic](http://localhost:9966/petclinic)

You should see a [Swagger UI][swagger] where you can play with the API.

Since the binding is not present in the application, you will see be any values in results.
In the next section, you will see how to fix it.

## Service Binding

The application was not working as the bindings were not present in the app.

Now you can create the ServiceBinding custom resource to inject the bindings:

```yaml
apiVersion: binding.operators.coreos.com/v1alpha1
kind: ServiceBinding
metadata:
    name: spring-petclinic-rest
    namespace: petclinic-demo
spec:
    services:
    - group: "crunchydata.com"
      version: v1
      kind: Pgcluster
      name: hippo
    - group: ""
      version: v1
      kind: Secret
      name: hippo-hippo-secret
    application:
      name: spring-petclinic-rest
      group: apps
      version: v1
      resource: deployments
    mappings:
    - name: type
      value: "postgresql"
```

For the convenience, the above resource can be installed like this:

```bash
kubectl apply -f https://gist.github.com/baijum/b99cd8e542868a00b2b5efc2e1b7dc10/raw/04eb5fe3d7f393af5a6760b03d9a1a3f5c725077/service-binding.yaml
```

The [next section](../creating-service-bindings/creating-service-binding)
explains the ServiceBinding configuration.

You can port-forward the application port and access it from your local system

```
kubectl port-forward --address 0.0.0.0 svc/spring-petclinic-rest 9966:80 -n petclinic-demo
```

You can open [http://localhost:9966/petclinic](http://localhost:9966/petclinic)

You should see a [Swagger UI][swagger] where you can play with the API.

[petclinic]: https://github.com/spring-petclinic/spring-petclinic-rest
[olm]: https://olm.operatorframework.io
[crunchy]: https://operatorhub.io/operator/postgresql
[operator-sdk]: https://sdk.operatorframework.io
[pack]: https://buildpacks.io/docs/tools/pack/
[swagger]: https://swagger.io
