---
sidebar_position: 2
---

# Advanced Binding Options

## Transform binding names before projection into application

Binding names declared through annotations or CSV descriptors are processed before injected into the application according to the following strategy
 - names are upper-cased
 - service resource kind is upper-cased and prepended to the name

example:
```yaml
DATABASE_HOST: example.com
```
`DATABASE` is backend service `Kind` and `HOST` is the binding name.

With custom naming strategy/templates we can build custom binding names.

Naming strategy defines a way to prepare binding names through
ServiceBinding request.

1. We have a nodejs application which connects to database.
2. Application mostly requires host address and exposed port information.
3. Application access this information through binding names.


#### How ?
Following fields are part of `ServiceBinding` request.
- Application
```yaml
  application:
    name: nodejs-app
    group: apps
    version: v1
    resource: deployments
```

- Backend/Database Service
```yaml
namingStrategy: 'POSTGRES_{{ .service.kind | upper }}_{{ .name | upper }}_ENV'
services:
  - group: postgresql.baiju.dev
    version: v1alpha1
    kind: Database
    name: db-demo
```

Considering following are the fields exposed by above service to use for binding
1. host
2. port

We have applied `POSTGRES_{{ .service.kind | upper }}_{{ .name | upper }}_ENV` naming strategy
1. `.name` refers to the binding name specified in the crd annotation or descriptor.
2. `.service` refer to the services in the `ServiceBinding` request.
3. `upper` is the string function used to postprocess the string while compiling the template string.
4. `POSTGRES` is the prefix used.
5. `ENV` is the suffix used.

Following would be list of binding names prepared by above `ServiceBinding`

```yaml
POSTGRES_DATABASE_HOST_ENV: example.com
POSTGRES_DATABASE_PORT_ENV: 8080
```

We can define how that key should be prepared defining string template in `namingStrategy`

#### Naming Strategies

There are few naming strategies predefine.
1. `none` - When this is applied, we get binding names in following form - `{{ .name }}`
```yaml
host: example.com
port: 8080
```


2. `uppercase` - This is by uppercase set when no `namingStrategy` is defined and `bindAsFiles` set to false - `{{ .service.kind | upper}}_{{ .name | upper }}`

```yaml
DATABASE_HOST: example.com
DATABASE_PORT: 8080
```

3. `lowercase` - This is by default set when `bindAsFiles` set to true -`{{ .name | lower }}`

```yaml
host: example.com
port: 8080
```

#### Predefined string post processing functions
1. `upper` - Capatalize all letters
2. `lower` - Lowercase all letters
3. `title` - Title case all letters.


## Compose custom binding variables <kbd>TBU</kbd>

If the backing service doesn't expose binding metadata or the values exposed are not easily consumable, then an application author may compose custom binding variables using attributes in the Kubernetes resource representing the backing service.

The *custom binding variables* feature enables application authors to request customized binding secrets using a combination of Go and jsonpath templating.

Example, the backing service CR may expose the host, port and database user in separate variables, but the application may need to consume this information as a connection string.


``` yaml
apiVersion: binding.operators.coreos.com/v1alpha1
kind: ServiceBinding
metadata:
  name: multi-service-binding
  namespace: service-binding-demo
spec:

  application:
    name: java-app
    group: apps
    version: v1
    resource: deployments

 services:
  - group: postgresql.baiju.dev
    version: v1alpha1
    kind: Database
    name: db-demo   <--- Database service
    id: postgresDB <--- Optional "id" field
  - group: ibmcloud.ibm.com
    version: v1alpha1
    kind: Binding
    name: mytranslator-binding <--- Translation service
    id: translationService

  mappings:
    ## From the database service
    - name: JDBC_URL
      value: 'jdbc:postgresql://{{ .postgresDB.status.dbConnectionIP }}:{{ .postgresDB.status.dbConnectionPort }}/{{ .postgresDB.status.dbName }}'
    - name: DB_USER
      value: '{{ .postgresDB.status.dbCredentials.user }}'

    ## From the translator service
    - name: LANGUAGE_TRANSLATOR_URL
      value: '{{ index translationService.status.secretName "url" }}'
    - name: LANGUAGE_TRANSLATOR_IAM_APIKEY
      value: '{{ index translationService.status.secretName "apikey" }}'

    ## From both the services!
    - name: EXAMPLE_VARIABLE
      value: '{{ .postgresDB.status.dbName }}{{ translationService.status.secretName}}'

    ## Generate JSON.
    - name: DB_JSON
      value: {{ json .postgresDB.status }}

```

This has been adopted in [IBM CodeEngine](https://cloud.ibm.com/docs/codeengine?topic=codeengine-kn-service-binding).


*In future releases, the above would be supported as volume mounts too.*