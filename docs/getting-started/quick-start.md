---
sidebar_position: 2
---

# Quick Start

In this quik start, you will see a sample application that you deploy and use to
play around.  As part of this exercise, a backing service and an application is
required.  The backing service is a PostgreSQL database and application is a
[Spring Boot REST API server][petclinic].

## Installing Operator Lifecycle Manager (OLM)

To install [Operator Lifecycle Manager][olm], run this command:

```
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.18.2/install.sh | bash -s v0.18.2
```

Alternately, if you have have [Operator SDK][operator-sdk] installed, run this
command:

```
operator-sdk olm install --version=v0.18.2
```

## Installing Crunchy PostgreSQL for Kubernetes Opeator

Crunchy PostgreSQL for Kubernetes opeator can be installed with this command:

```
kubectl create -f https://operatorhub.io/install/postgresql.yaml
```

The operator will be installed in the `my-postgresql` namespace and will be usable from this namespace only.

After install, watch your operator come up using this command:

```
$ kubectl get csv -n my-postgresql
```

Wait until you see a message something like this:

```
NAME                      DISPLAY                             VERSION   REPLACES                  PHASE
postgresoperator.v4.7.0   Crunchy PostgreSQL for Kubernetes   4.7.0     postgresoperator.v4.6.2   Succeeded
```

## Creating a PostgreSQL Cluster using a Custom Resource

To create the PostgreSQL cluster:

```
# name of the cluster
export pgo_cluster_name=hippo

# namespace of the cluster
export cluster_namespace=my-postgresql

# location of the image repository
export cluster_image_prefix=registry.developers.crunchydata.com/crunchydata

cat <<-EOF > "${pgo_cluster_name}-pgcluster.yaml"
apiVersion: crunchydata.com/v1
kind: Pgcluster
metadata:
  annotations:
    current-primary: ${pgo_cluster_name}
  labels:
    crunchy-pgha-scope: ${pgo_cluster_name}
    deployment-name: ${pgo_cluster_name}
    name: ${pgo_cluster_name}
    pg-cluster: ${pgo_cluster_name}
    pgo-version: 4.7.0
    pgouser: admin
  name: ${pgo_cluster_name}
  namespace: ${cluster_namespace}
spec:
  BackrestStorage:
    accessmode: ReadWriteMany
    matchLabels: ""
    name: ""
    size: 1G
    storageclass: ""
    storagetype: create
    supplementalgroups: ""
  PrimaryStorage:
    accessmode: ReadWriteMany
    matchLabels: ""
    name: ${pgo_cluster_name}
    size: 1G
    storageclass: ""
    storagetype: create
    supplementalgroups: ""
  ReplicaStorage:
    accessmode: ReadWriteMany
    matchLabels: ""
    name: ""
    size: 1G
    storageclass: ""
    storagetype: create
    supplementalgroups: ""
  annotations: {}
  ccpimage: crunchy-postgres-ha
  ccpimageprefix: ${cluster_image_prefix}
  ccpimagetag: centos8-13.3-4.7.0
  clustername: ${pgo_cluster_name}
  database: ${pgo_cluster_name}
  exporterport: "9187"
  limits: {}
  name: ${pgo_cluster_name}
  pgDataSource:
    restoreFrom: ""
    restoreOpts: ""
  pgbadgerport: "10000"
  pgoimageprefix: ${cluster_image_prefix}
  podAntiAffinity:
    default: preferred
    pgBackRest: preferred
    pgBouncer: preferred
  port: "5432"
  tolerations: []
  user: hippo
  userlabels:
    pgo-version: 4.7.0
EOF

kubectl apply -f "${pgo_cluster_name}-pgcluster.yaml"
```

Ensure all the pods in `my-postgresql` is running (it will take few minutes):

```
kubectl get pod -n my-postgresql
```

## Verifying PostgreSQL Connection and Create Schema

To verify the PostgreSQL connection:

```
# name of the user
export pgo_cluster_username=hippo

# get the password of the user and set it to a recognized psql environmental variable
export PGPASSWORD=$(kubectl -n "${cluster_namespace}" get secrets \
  "${pgo_cluster_name}-${pgo_cluster_username}-secret" -o "jsonpath={.data['password']}" | base64 -d)

# set up a port-forward either in a new terminal, or in the same terminal in the background:
kubectl -n ${cluster_namespace} port-forward svc/hippo 5432:5432 &

psql -h localhost -U "${pgo_cluster_username}" "${pgo_cluster_name}"
```

Download the schema and sample data load it to the database:

```
curl -LO https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/master/src/main/resources/db/postgresql/initDB.sql

psql -h localhost -U "${pgo_cluster_username}" "${pgo_cluster_name}" -f initDB.sql

curl -LO https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/master/src/main/resources/db/postgresql/populateDB.sql

psql -h localhost -U "${pgo_cluster_username}" "${pgo_cluster_name}" -f populateDB.sql
```

## Building the PetClinic App

Create a directory with files required for database connection.  The values need
not be correct as it will be projected through Service Binding:

```
mkdir /tmp/postgres
cd /tmp/postgres
touch database  host  password  port  type  username
```

Clone the PetClinic repository:

```
git clone https://github.com/spring-petclinic/spring-petclinic-rest.git
```

Note: The above fork of PetClinic was choosen as it has PostgreSQL support

You need [Build Packs CLI][pack] to build the container image.

```
pack build --path . --builder paketobuildpacks/builder:base --volume /tmp/postgres:/platform/bindings/postgres spring-petclinic-rest
```

Now you can create a tag of the image and push to quay.io:

```
docker tag spring-petclinic-rest:latest quay.io/<username>/spring-petclinic-rest:latest
docker push quay.io/<username>/spring-petclinic-rest:latest
```

Replace `<username>` with your quay.io username.  After pushing the image to
quay.io, make it as a public image to continue with this quick start.

## Application Deployment

Now you can deploy your app with this `Deployment` configuration:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spring-petclinic-rest
  labels:
    app: spring-petclinic-rest
spec:
  replicas: 1
  selector:
    matchLabels:
      app: spring-petclinic-rest
  template:
    metadata:
      labels:
        app: spring-petclinic-rest
    spec:
      containers:
        - name: application
          image: quay.io/<username>/spring-petclinic-rest:latest
          env:
          - name: SPRING_PROFILES_ACTIVE
            value: postgresql,spring-data-jpa
          ports:
          - name: http
            containerPort: 9966
```

You can also create a `Service`:

```
apiVersion: v1
kind: Service
metadata:
  name: spring-petclinic-rest
spec:
  ports:
  - port: 80
    targetPort: 9966
  selector:
    app: spring-petclinic-rest
```

You can create the Secret resource based on the database created earlier:

```
apiVersion: v1
kind: Secret
metadata:
  name: spring-petclinic-rest-db
type: service.binding/postgresql
stringData:
  type: "postgresql"
  host: "hippo"
  port: "5432"
  database: "hippo"
  username: "hippo"
  password: "LY)Bng@yWceQ70O@VX@AlO(:"
```

Now it's ready to create the ServiceBinding custom resource:

```
apiVersion: binding.operators.coreos.com/v1alpha1
kind: ServiceBinding
metadata:
    name: spring-petclinic-rest
spec:
    services:
    - group: ""
      version: v1
      kind: Secret
      name: spring-petclinic-rest-db
    application:
      name: spring-petclinic-rest
      group: apps
      version: v1
      resource: deployments
```

You can port-forward the application port and access it from your local system

```
kubectl port-forward svc/spring-petclinic-rest 9966:80 -n my-postgresql
```

You can open http://localhost:9966/petclinic

You should see a [Swagger UI][swagger] where you can play with the API.

[petclinic]: https://github.com/spring-petclinic/spring-petclinic-rest
[olm]: https://olm.operatorframework.io
[operator-sdk]: https://sdk.operatorframework.io
[pack]: https://buildpacks.io/docs/tools/pack/
[swagger]: https://swagger.io
