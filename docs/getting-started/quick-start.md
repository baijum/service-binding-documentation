---
sidebar_position: 2
---

# Quick Start

In this quik start, you will see a sample application that you can deploy and
use to play around.  As part of this exercise, a backing service and an
application is required.  The backing service is a PostgreSQL database and
application is a [Spring Boot REST API server][petclinic].

## Database Backend

You can install [Crunchy PostgreSQL from OperatorHub.io][crunchy].  After the
installation, to create a PostgreSQL cluster, download this shell script and run
it:

```
kubectl apply -f https://gist.github.com/baijum/b99cd8e542868a00b2b5efc2e1b7dc10/raw/093f3ef729d7eb26c3f461c77b0089bd7c358e49/pgcluster.sh
```

Ensure all the pods in `my-postgresql` is running (it will take few minutes):

```
kubectl get pod -n my-postgresql
```

You should see output something like this:

```
NAME                                          READY   STATUS    RESTARTS   AGE
backrest-backup-hippo-9gtqf                   1/1     Running   0          13s
hippo-597dd64d66-4ztww                        1/1     Running   0          3m33s
hippo-backrest-shared-repo-66ddc6cf77-sjgqp   1/1     Running   0          4m27s
```

Now you can initialize the database:

```
bash <(curl -s https://gist.githubusercontent.com/baijum/b99cd8e542868a00b2b5efc2e1b7dc10/raw/603e288541dbd1d55596ca1b520d7f2a4f1ce76b/init-database.sh)>
```

## Application Deployment

Now you can deploy the `spring-petclinic-rest` app with this `Deployment`
configuration:

```
kubectl apply -f https://gist.github.com/baijum/b99cd8e542868a00b2b5efc2e1b7dc10/raw/093f3ef729d7eb26c3f461c77b0089bd7c358e49/app-deployment.sh
```

## Service Binding

Now you cab create the ServiceBinding custom resource:

```
cat <<-EOF > "spring-petclinic-rest-binding.yaml"
apiVersion: binding.operators.coreos.com/v1alpha1
kind: ServiceBinding
metadata:
    name: spring-petclinic-rest
	namespace: my-postgresql
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
EOF

kubectl apply -f "spring-petclinic-rest-binding.yaml"
```

You can port-forward the application port and access it from your local system

```
kubectl port-forward --address 0.0.0.0 svc/spring-petclinic-rest 9966:80 -n my-postgresql
```

You can open [http://localhost:9966/petclinic](http://localhost:9966/petclinic)

You should see a [Swagger UI][swagger] where you can play with the API.

[petclinic]: https://github.com/spring-petclinic/spring-petclinic-rest
[olm]: https://olm.operatorframework.io
[crunchy]: https://operatorhub.io/operator/postgresql
[operator-sdk]: https://sdk.operatorframework.io
[pack]: https://buildpacks.io/docs/tools/pack/
[swagger]: https://swagger.io
