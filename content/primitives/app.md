# App

## AppCreate

Creates a new app.

### Request

```shell
$ curl -X POST --data "name=test-app" https://example.com/apps
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  r, err := rack.NewFromEnv()

  app, err := r.AppCreate("test-app")
}
```

`POST /apps`

### Parameters

The following should be sent as POST data:

| Parameter | Default | Required | Description              |
|-----------|---------|----------|--------------------------|
| **name**  |         | yes      | The name of the new App. |

### Response

```shell
{
  "name": "test-app",
  "release": "",
  "status": "creating"
}
```

```go
&types.App{
  Name:    "test-app",
  Release: "",
  Status:  "creating",
}
```

A JSON object with the following fields is returned:

| Parameter | Description                     |
|-----------|---------------------------------|
| name      | The name of the App.            |
| release   | The current Release of the App. |
| status    | The current status of the App.  |

## AppDelete

```shell
curl -X DELETE https://example.com/apps/test-app
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  r, err := rack.NewFromEnv()

  err := r.AppDelete("test-app")
}
```

> The HTTP request returns an empty response with a status code.

Deletes a specific app.

### HTTP Request

`DELETE /apps/test-app`

## AppGet

```shell
curl https://example.com/apps/test-app
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  r, err := rack.NewFromEnv()

  app, err := r.AppGet("test-app")
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

## AppList

```shell
curl http://example.com/apps
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  r, err := rack.NewFromEnv()

  apps, err := r.AppList()
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

## AppLogs

```shell
curl https://example.com/apps/test-app/logs
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  r, err := rack.NewFromEnv()

  logs, err := rack.AppLogs("test-app", types.LogsOptions{Follow: true})

  io.Copy(os.Stdout, logs)
}
```

Stream an app’s logs.

### HTTP Request

`GET /apps/test-app/logs`
