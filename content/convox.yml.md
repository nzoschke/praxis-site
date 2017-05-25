---
title: convox.yml reference
weight: 10
---

# convox.yml

```shell
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
    image: my/api
    resources:
      - database
  monitor:
    image: my/monitor
    scale: 1
  web:
    build: .
    command:
      development: bin/web-dev
      test: bin/web-test
      production: bin/web-prod
    environment:
      - FOO=bar
    health: /auth
    port: 3000
    scale:
      count: 2-10
      cpu: 512
      memory: 1024
timers:
  cleanup:
    schedule: 0 3 * * *
    command: bin/cleanup
    service: web
workflows:
  change:
    create:
      - test
      - create: staging/example-$branch
      - deploy: staging/example-$branch
    update:
      - test
      - deploy: staging/example-$branch
    close:
      - delete: staging/example-$branch
  merge:
    master:
      - test
      - deploy: staging/example-staging
      - copy: production/example-production
```

The `convox.yml` file is a configuration file used to describe your application and all of its infrastructure needs. The yaml in API tab to the right demonstrates the configuration for an example application. 

### The Manifest

When you deploy your application, `convox.yml` is read and turned into a data structure called a "manifest". The manifest is the backbone of your application. It fully describes everything needed to run it anywhere. During the deployment process, Convox will intelligently manage all of the infrastructure needed to satisfy the manifest.

In the language tabs to the right you can see how each language SDK represents the manifest. This will come in handy when you start using the SDK to interact with the Praxis API, as described later in this document.

### Configurable Primitives

Each stanza of the `convox.yml` file is dedicated to a different primitive. Currently, the following 7 primitives are configurable:

* **Caches** - Key/value stores for volatile data
* **Keys** - Encryption keys
* **Queues** - Shared lists of messages
* **Resources** - Network-attached dependencies of the app
* **Services** - Your application process(es)
* **Timers** - Recurring, scheduled tasks
* **Workflows** - A list of tasks executed sequentially in response to an event

In the following sections we will take a close look at each primitive and explore its configuration options.

## caches

```yaml
caches:
  sessions:
    expire: 1d
```

### expire

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

```go
manifest.Service{
  Build: manifest.ServiceBuild{
    Path: ".",
  },
  Certificate: "",
  Command: manifest.ServiceCommand{
    Development: "make dev",
    Test: "make test",
  },
  Environment: []string{
    "FOO",
    "BAR=baz",
  },
  Health: manifest.ServiceHealth{
    Interval: 5,
    Timeout: 4,
    Path: "/health",
  },
  Image: "ubuntu:16.04",
  Port: manifest.ServicePort{
    Port: 3000,
    Scheme: "http",
  },
  Scale: manifest.ServiceScale{
    Count: manifest.ServiceCount{
      Min: 3,
      Max: 3,
    },
    Memory: 1024,
  },
}
```

```yaml
services:
  web:
    build: .
    command:
      development: make dev
      test: make test
    environment:
      - FOO
      - BAR=baz
    health: /health
    image: ubuntu:16.04
    port: 3000
    resources:
      - database
    scale:
      count: 3
      memory: 1024
```

### build

The directory inside the project in which to find the Dockerfile needed to build a particular service. Paths are relative to the location of `convox.yml`.

### command

The default command to run for a particular service. This overides `CMD` in the Dockerfile.

### environment

Define default environment variables for the service.

### health

The path that should be requested by the balancer's HTTP healthcheck of the service.

### image

The image that should be used for running the service.

### port

The protocol and port on which the process is listening.

### resources

The resources enumerated in the `resources` section that should be available to the service.

### scale

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
      - create: staging/example-$branch
      - deploy: staging/example-$branch
    update:
      - test
      - deploy: staging/example-$branch
    close:
      - delete: staging/example-$branch
```

Actions defined within a change block take place when the state of a pull request changes. There are 3 types of changes: create, update, and close

#### create

```yaml
workflows:
  change:
    create:
      - test
      - create: staging/example-$branch
      - deploy: staging/example-$branch
```

Actions defined within a create block take place when a pull request is created.

#### update

```yaml
workflows:
  change:
    update:
      - test
      - deploy: staging/example-$branch
```

Actions defined within an update block take place when a pull request is updated.

#### close

```yaml
workflows:
  change:
    close:
      - delete: staging/example-$branch
```

Actions defined within the close block take place when a pull request is closed.

### merge

```yaml
workflows:
  merge:
    master:
      - test
      - deploy: staging/example-staging
      - copy: production/example-production
```

Actions defined within a merge block take place when commits are merged into or pushed directly to the specified branch.
