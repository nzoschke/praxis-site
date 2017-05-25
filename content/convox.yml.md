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

```shell
caches:
  sessions:
    expire: 1d
```

A cache is a place where you can store volatile data for fast access. Some example uses for a cache could be storing user sessions, web page partials for faster load times, or the results of expensive database queries. To configure a cache give it a name and a default expiration for the items in the cache.

In this example a cache called `sessions` is set up with default item expiration of 1 day.

### Attributes:

### expire

The default time to live for items in the cache.

## keys

```shell
keys:
  secret:
    roll: 30d
```

A key is an encryption key that you can use to easily encrypt and decrypt sensitive data. For more information on how to use keys check out the [API documentation](#key).

This example configures a key called `secret` that gets rolled every 30 days.

### Attributes:

### roll

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

```shell
services:
  web:
    build: .
    certificate: ${HOST}
    command:
      development: make dev
      test: make test
    environment:
      - FOO=bar
      - HOST
    health: /health
    image: ubuntu:16.04
    port: 3000
    resources:
      - database
    scale:
      count: 3
      memory: 1024
```

```go
manifest.Service{
  Build: manifest.ServiceBuild{
    Path: ".",
  },
  Certificate: "www.example.com",
  Command: manifest.ServiceCommand{
    Development: "make dev",
    Test: "make test",
  },
  Environment: []string{
    "FOO=bar",
    "HOST",
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
  Resources: []string{},
  Scale: manifest.ServiceScale{
    Count: manifest.ServiceCount{
      Min: 3,
      Max: 3,
    },
    Memory: 1024,
  },
}
```


Services are the blueprints for your application's processes. They are based on Docker images either specified by name or built from your code. They can be web services configured to listen on specific ports or they can be background workers processing tasks from a queue, for example.

### Attributes:

### build

A directory inside the project in which to find the Dockerfile needed to build a particular service. Paths are relative to the location of `convox.yml`. If the Dockerfile is in the top level directory it is not necessary to specify a build location. `build .` is shown here for illustrative purposes.

### certificate

Convox can automatically generate and configure SSL certificates for a specified domain. Here we have `certificate: ${HOST}`. That means a certificate should be set up for the domain specified by the `HOST` environment variable. This allows Convox to dynamically generate the correct certificate based on your current environment.

### command

The default command to run for a particular service. If no `command` is specified, then `CMD` from the Dockerfile will be used. If `command` is specified it overides `CMD` in the Dockerfile.

### environment

A list of strings that define the service's environment variables.

A pair like `FOO=bar` creates an environment variable named `FOO` with a value of `bar`.

A single variable name like `HOST` simply whitelists the variable name `HOST`.

You should not configure secrets here, as they would be recorded in version control. For secrets, simply whitelist the variable name, then set the actual value using the CLI `cx env set` command.

You can also use the CLI to override default values set in `convox.yml`.

### health

The path that should be requested by the balancer's HTTP healthcheck of the service. If you don't specify a path then the root path `/` will be used by default.

### image

The Docker image that should be used for running the service. If you specify an image, then no build will occur for this service.

### port

The internal container port on which the service's processes are listening. Convox will route all HTTP and HTTPS requests to the appliction to this port.

Each service with open ports will be given a unique domain. You can fetch those domain names using the `cx services` CLI command.

### resources

The resources enumerated in the `resources` section that should be available to the service.

### scale

A range specifying the number processes that should be run for the service. The exact value within the range is determined by an autoscaling algorithm. This is optional. If you do not specify a scale then 1 process will be run for the service.

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
