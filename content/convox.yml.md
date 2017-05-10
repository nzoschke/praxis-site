---
title: convox.yml reference
weight: 0
---

# convox.yml

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

The `convox.yml` file is a configuration file used to describe your application and all of its infrastructure needs.

## balancers

### draining-timeout

```yaml
balancers:
  web:
    draining-timeout: 300
```

The amount of time in seconds to allow a draining balancer to keep active connections open. After the timeout, the load balancer will close all connections to a deregistered or unhealthy instance. The minimum value is 1 and the maximum is 3600. The default value is 60.

### idle-timeout

```yaml
balancers:
  web:
    idle-timeout: 3000
```

The amount of time in seconds a balancer should wait for data to be sent by the client of a connection. If no data is sent, the balancer will terminate the front-end connection. Valid values are between 1 and 3600. The default is 60.

## caches

### expire

```yaml
caches:
  sessions:
    expire: 1d
```

The default time to live for items in the cache.

## keys

### roll

```yaml
keys:
  secret:
    roll: 30d
```

How often to roll keys.

## queues

### timeout

```yaml
queues:
  mail:
    timeout: 1m
```

The default timeout for items in a queue.

## resources

### type

```yaml
resources:
  database:
    type: postgres
```

The type of resource to create.

## services

### agent

```yaml
services:
  monitor:
    agent: true
```

Boolean value to set whether this service should be run as an agent (exactly one per instance). The default value is `false`.

### build

```yaml
services:
  web:
    build: .
```

The directory inside the project in which to find the Dockerfile needed to build a particular service. Paths are relative to the location of `convox.yml`.

### command

```yaml
services:
  web:
    command: bin/web
```

The default command to run for a particular service. This overides `CMD` in the Dockerfile.

### cpu

```yaml
services:
  web:
    cpu: 512
```

The number of CPU shares in an instance to dedicate to a particular service. Each CPU core on an instance represents 1024 shares.

### dockerfile

```yaml
services:
  web:
    dockerfile: Dockerfile.alt
```

An alternate filename of the Dockerfile that should be used to build the a particular service's image, if not "Dockerfile".

### entrypoint

```yaml
services:
  web:
    entrypoint: bin/entrypoint.sh
```

Can be used to define an entrypoint script or override ENTRYPOINT in the Dockerfile.

### environment

```yaml
services:
  web:
    environment:
      - FOO=bar
```

Define default environment variables for the service.

### health

```yaml
services:
  web:
    health: /auth
```

The path that should be requested by the balancer's HTTP healthcheck of the service.

### image

```yaml
services:
  monitor:
    image: my/monitor
```

The image that should be used for running the service.

### links

```yaml
services:
    links:
      - api
```

Specifying a link to another process instructs Convox to provide the linking process with environment variables that allow it to connect to the target process.

### memory

```yaml
services:
  web:
    memory: 1024
```

The amount of instance memory, in MB, that should be dedicated to processes of this service type.

### port

```yaml
services:
  web:
    port: http:3000
```

The protocol and port on which the process is listening.

### privileged

```yaml
services:
  web:
    privileged: true
```

A boolean value that sets whether the processes of this service type should be run as privileged containers on the instance. The default value is `false`.

### resources

```yaml
services:
  api:
    resources:
      - database
```

The resources enumerated in the `resources` section that should be available to the service.

### scale

```yaml
services:
 web:
  scale: 2-10
```

The range of count of processes that should be run for the service. The exact value within the range is determined by an autoscaling algorithm.

## tables

## timers

### command

```yaml
timers:
  cleanup:
    command: bin/cleanup
```

The command to be executed when the timer triggers.

### schedule

```yaml
timers:
  cleanup:
    schedule: 0 3 * * *
```

A [cron-like schedule expression](#) that sets when the timer will trigger.

### service

```yaml
timers:
  cleanup:
    service: web
```

The service in which the command should be run.

## workflows

### change

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

Actions defined within a change block take place when the state of a pull request changes. There are 3 types of changes: create, update, and close

#### create

```yaml
workflows:
  change:
    create:
      - test
      - create: staging/myapp-$branch
      - deploy: staging/myapp-$branch
```

Actions defined within a create block take place when a pull request is created.

#### update

```yaml
workflows:
  change:
    update:
      - test
      - deploy: staging/myapp-$branch
```

Actions defined within an update block take place when a pull request is updated.

#### close

```yaml
workflows:
  change:
    close:
      - delete: staging/myapp-$branch
```

Actions defined within the close block take place when a pull request is closed.

### merge

```yaml
workflows:
  merge:
    master:
      - test
      - deploy: staging/myapp-staging
      - copy: production/myapp-production
```

Actions defined within a merge block take place when commits are merged into or pushed directly to the specified branch.

