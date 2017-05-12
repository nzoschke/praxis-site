# App

## List All Apps

```shell
curl http://example.com/apps
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  apps, err := rack.AppList()
}
```

> The HTTP request returns JSON structured like this:

```json
[
  {
    "Name":"foo",
    "Release":"RYEQCJGDNC",
    "Status":"running"
  },
  {
    "Name":"test-app",
    "Release":"",
    "Status":"creating"
  }
]
```

Returns a list of all apps in this rack.

### HTTP Request

`POST /apps`

## Create an App

```shell
curl -X POST --data "name=test-app" https://example.com/apps
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  app, err := rack.AppCreate("test-app")
}
```

> The HTTP request returns JSON structured like this:

```json
{
  "Name":"test-app",
  "Release":"",
  "Status":"creating"
}
```

Creates a new app.

### HTTP Request

`POST /apps`

### Parameters

The following should be sent as POST data:

Parameter | Default | Required | Description
--------- | ------- | -------- | -----------
name      |         | yes      | The name of the new app to create.


## Get a Specific App

```shell
curl https://example.com/apps/test-app
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  app, err := rack.AppGet("test-app")
}
```

> The HTTP request returns JSON structured like this:

```json
{
  "Name":"test-app",
  "Release":"RJREHTRSNKP",
  "Status":"running"
}
```

Fetch info about a specific app.

### HTTP Request

`GET /apps/test-app`

## Delete an App

```shell
curl -X DELETE https://example.com/apps/test-app
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  err := rack.AppDelete("test-app")
}
```

> The HTTP request returns an empty response with a status code.

Deletes a specific app.

### HTTP Request

`DELETE /apps/test-app`

## Logs for an App

```shell
curl https://example.com/apps/test-app/logs
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  logs, err := rack.AppLogs("test-app", types.LogsOptions{Follow: true})
}
```

Stream an app’s logs.

### HTTP Request

`GET /apps/test-app/logs`

## Registry Info for an App

```shell
curl https://example.com/apps/test-app/registry
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  registry, err := rack.AppRegistry("test-app")
}
```

> The HTTP request returns JSON formatted like this:

```json
{
  "Hostname":"788638754432.dkr.ecr.us-east-1.amazonaws.com",
  "Username":"AWS",
  "Password":"<base64-encoded password string>"
}
```

Fetch login info for an app's registry.

### HTTP Request

`GET /apps/test-app/registry
