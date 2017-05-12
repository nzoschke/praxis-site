# App

## Create

Create a new App

```shell
$ curl -X POST --data "name=example" $RACK_URL/apps
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  app, err := rack.AppCreate("example")
}
```

### Request

`POST /apps`

### Parameters

The following should be sent as POST data:

| Parameter | Default | Required | Description             |
|-----------|---------|----------|-------------------------|
| **name**  |         | yes      | The name of the new App |

```shell
{
  "name": "example",
  "release": "",
  "status": "creating"
}
```

```go
&types.App{
  Name:    "example",
  Release: "",
  Status:  "creating",
}
```

### Response

An object with the following fields is returned:

| Parameter | Description                    |
|-----------|--------------------------------|
| name      | The name of the App            |
| release   | The current Release of the App |
| status    | The current status of the App  |

## Delete

Delete an App

```shell
$ curl -X DELETE $RACK_URL/apps/example
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  err := rack.AppDelete("example")
}
```

### Request

`DELETE /apps/test-app`

## Get

Get information about an App

```shell
$ curl $RACK_URL/apps/example
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  app, err := rack.AppGet("test-app")
}
```

### Request

`GET /apps/test-app`

```shell
{
  "Name": "example",
  "Release": "RJREHTRSNKP",
  "Status": "running"
}
```

```go
&types.App{
  Name:    "example",
  Release: "",
  Status:  "creating",
}
```

### Response

An object with the following fields is returned:

| Parameter | Description                    |
|-----------|--------------------------------|
| name      | The name of the App            |
| release   | The current Release of the App |
| status    | The current status of the App  |

## List

List available Apps

```shell
$ curl $RACK_URL/apps
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  apps, err := rack.AppList()
}
```

### Request

`POST /apps`

```shell
[
  {
    "Name": "example",
    "Release": "RYEQCJGDNC",
    "Status": "running"
  },
  {
    "Name": "example2",
    "Release": "",
    "Status": "creating"
  }
]
```

```go
&types.App{
  Name:    "example",
  Release: "",
  Status:  "creating",
}
```

### Response

A list of objects with the following fields are returned:

| Parameter | Description                    |
|-----------|--------------------------------|
| name      | The name of the App            |
| release   | The current Release of the App |
| status    | The current status of the App  |

## Logs

Stream available logs for an App.

```shell
$ curl $RACK_URL/apps/example/logs
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  logs, err := rack.AppLogs("example", types.LogsOptions{
    Follow: true,
  })
}
```

### Request

`GET /apps/test-app/logs`

### Parameters

| Parameter  | Default   | Required | Description                      |
|------------|-----------|----------|----------------------------------|
| **filter** |           | no       | Filter log output                |
| **follow** | *false*   | no       | Continue to stream new logs      |
| **since**  | *2m*      | no       | Display logs since this duration |

```shell
2017-01-01 00:00:00 example/web/937fa3b04027 test logs
2017-01-01 00:00:00 example/web/937fa3b04027 more logs
```

```go
io.Copy(os.Stdout, logs)
```

### Response

The logs are streamed in the HTTP response.