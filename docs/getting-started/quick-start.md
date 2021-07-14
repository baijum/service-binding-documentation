---
sidebar_position: 2
---

# Quick Start

In this quick start, you will see a sample application that you can deploy and
use to play around.  As part of this exercise, a backing service and an
application is required.  The backing service is a PostgreSQL database and
application is a [Spring Boot REST API server][petclinic].

## Database Backend

You can install [Crunchy PostgreSQL from OperatorHub.io][crunchy].  After the
installation, to create a PostgreSQL cluster, run this command:

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

Now you can initialize the database with this command:

```bash
bash <(curl -s https://gist.github.com/baijum/b99cd8e542868a00b2b5efc2e1b7dc10/raw/04eb5fe3d7f393af5a6760b03d9a1a3f5c725077/init-database.sh)>
```

## Application Deployment

Now you can deploy the `spring-petclinic-rest` app with this `Deployment`
configuration:

```bash
kubectl apply -f https://gist.github.com/baijum/b99cd8e542868a00b2b5efc2e1b7dc10/raw/04eb5fe3d7f393af5a6760b03d9a1a3f5c725077/app-deployment.yaml
```

## Service Binding

Now you can create the ServiceBinding custom resource:

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

For the convenience, the above configuration can be installed like this:

```bash
kubectl apply -f https://gist.github.com/baijum/b99cd8e542868a00b2b5efc2e1b7dc10/raw/04eb5fe3d7f393af5a6760b03d9a1a3f5c725077/service-binding.yaml
```


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
