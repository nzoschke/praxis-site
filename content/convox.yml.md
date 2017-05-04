+++
title = "convox.yml"

[menu.main]
  identifier = "convox.yml"
  parent = ""
+++

The `convox.yml` file is a configuration file used to describe your application and all of its infrastructure needs.

```
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
    image: myimage
    command: bin/web
      development: bin/web-dev
      test: bin/web-test
    environment:
      - FOO=bar
    health: /auth
    port: http:3000
    resources:
      - database
    scale: 2-10
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
