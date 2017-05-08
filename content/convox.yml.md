+++
title = "convox.yml"

[menu.main]
  identifier = "convox.yml"
  parent = ""
+++

The `convox.yml` file is a configuration file used to describe your application and all of its infrastructure needs.

```yaml
balancers:
  web:
    draining-timeout: 300
    idle-timeout: 3000
caches:
  sessions:
    expire: 1d
keys:
  secret:
    roll: 30d
queues:
  mail:
    timeout: 1m
resources:
  database:
    type: postgres
services:
  api:
    deployment:
      maximum: 200
      minimum: 50
    image: my/api
    resources:
      - database
  monitor:
    image: my/monitor
    agent: true
  web:
    build: .
    command: bin/web
      development: bin/web-dev
      test: bin/web-test
    cpu: 512
    dockerfile: Dockerfile.alt
    entrypoint: bin/entrypoint.sh
    environment:
      - FOO=bar
    health: /auth
    links:
      - api
    memory: 1024
    port: http:3000
    privileged: true
    scale: 2-10
tables:
timers:
  cleanup:
    schedule: 0 3 * * *
    command: bin/cleanup
    service: web
workflows:
  change:
    create:
      - test
      - create: staging/myapp-$branch
      - deploy: staging/myapp-$branch
    update:
      - test
      - deploy: staging/myapp-$branch
    close:
      - delete: staging/myapp-$branch
  merge:
    master:
      - test
      - deploy: staging/myapp-staging
      - copy: production/myapp-production
```

## balancers

### draining-timeout

The amount of time in seconds to allow a draining balancer to keep active connections open. After the timeout, the load balancer will close all connections to a deregistered or unhealthy instance. The minimum value is 1 and the maximum is 3600. The default value is 60.

```yaml
balancers:
  web:
    draining-timeout: 300
```

### idle-timeout

The amount of time in seconds a balancer should wait for data to be sent by the client of a connection. If no data is sent, the balancer will terminate the front-end connection. Valid values are between 1 and 3600. The default is 60.

```yaml
balancers:
  web:
    idle-timeout: 3000
```

## caches

### expire

The default time to live for items in the cache.

```yaml
caches:
  sessions:
    expire: 1d
```

## keys

### roll

How often to roll keys.

```yaml
keys:
  secret:
    roll: 30d
```

## queues

### timeout

The default timeout for items in a queue.

```yaml
queues:
  mail:
    timeout: 1m
```

## resources

### type

The type of resource to create.

```yaml
resources:
  database:
    type: postgres
```

## services

### agent

Boolean value to set whether this service should be run as an agent (exactly one per instance). The default value is `false`.

```yaml
services:
  monitor:
    agent: true
```

### build

The directory inside the project in which to find the Dockerfile needed to build a particular service. Paths are relative to the location of `convox.yml`.

```yaml
services:
  web:
    build: .
```

### command

The default command to run for a particular service. This overides `CMD` in the Dockerfile.

```yaml
services:
  web:
    command: bin/web
```
### cpu

The number of CPU shares in an instance to dedicate to a particular service. Each CPU core on an instance represents 1024 shares.

```yaml
services:
  web:
    cpu: 512
```

### dockerfile

An alternate filename of the Dockerfile that should be used to build the a particular service's image, if not "Dockerfile".

```yaml
services:
  web:
    dockerfile: Dockerfile.alt
```

### entrypoint

Can be used to define an entrypoint script or override ENTRYPOINT in the Dockerfile.

```yaml
services:
  web:
    entrypoint: bin/entrypoint.sh
```

### environment

Define default environment variables for the service.

```yaml
services:
  web:
    environment:
      - FOO=bar
```

### health

The path that should be requested by the balancer's HTTP healthcheck of the service.

```yaml
services:
  web:
    health: /auth
```

### image

The image that should be used for running the service.

```yaml
services:
  monitor:
    image: my/monitor
```

### links

Specifying a link to another process instructs Convox to provide the linking process with environment variables that allow it to connect to the target process.

```yaml
services:
    links:
      - api
```

### memory

The amount of instance memory, in MB, that should be dedicated to processes of this service type.

```yaml
services:
  web:
    memory: 1024
```

### port

The protocol and port on which the process is listening.

```yaml
services:
  web:
    port: http:3000
```

### privileged

A boolean value that sets whether the processes of this service type should be run as privileged containers on the instance. The default value is `false`.

```yaml
services:
  web:
    privileged: true
```

### resources

The resources enumerated in the `resources` section that should be available to the service.

```yaml
services:
  api:
    resources:
      - database
```

### scale

The range of count of processes that should be run for the service. The exact value within the range is determined by an autoscaling algorithm.

```yaml
services:
 web:
  scale: 2-10
```

## tables

## timers

### command

The command to be executed when the timer triggers.

```yaml
timers:
  cleanup:
    command: bin/cleanup
```

### schedule

A [cron-like schedule expression](#) that sets when the timer will trigger.

```yaml
timers:
  cleanup:
    schedule: 0 3 * * *
```

### service

The service in which the command should be run.

```yaml
timers:
  cleanup:
    service: web
```

## workflows

### change

Actions defined within a change block take place when the state of a pull request changes. There are 3 types of changes: create, update, and close

```yaml
workflows:
  change:
    create:
      - test
      - create: staging/myapp-$branch
      - deploy: staging/myapp-$branch
    update:
      - test
      - deploy: staging/myapp-$branch
    close:
      - delete: staging/myapp-$branch
```

#### create

Actions defined within a create block take place when a pull request is created.

```yaml
workflows:
  change:
    create:
      - test
      - create: staging/myapp-$branch
      - deploy: staging/myapp-$branch
```

#### update

Actions defined within an update block take place when a pull request is updated.

```yaml
workflows:
  change:
    update:
      - test
      - deploy: staging/myapp-$branch
```

#### close

Actions defined within the close block take place when a pull request is closed.

```yaml
workflows:
  change:
    close:
      - delete: staging/myapp-$branch
```

### merge

Actions defined within a merge block take place when commits are merged into or pushed directly to the specified branch.

```yaml
  merge:
    master:
      - test
      - deploy: staging/myapp-staging
      - copy: production/myapp-production
```

