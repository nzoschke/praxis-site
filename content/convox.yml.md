+++
title = "convox.yml"

[menu.main]
  identifier = "convox.yml"
  parent = ""
+++

The `convox.yml` file is a configuration file used to describe your application and all of its infrastructure needs.

```
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
    dockerfile: Dockerfile.alt
    entrypoint: bin/entrypoint.sh
    environment:
      - FOO=bar
    health: /auth
    links:
      - api
    port: http:3000
    privileged: true
    scale: 2-10
      cpu: 512
      memory: 1024
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
    close:
      - delete: staging/myapp-$branch
  merge:
    master:
      - test
      - deploy: staging/myapp-staging
      - copy: production/myapp-production
```
