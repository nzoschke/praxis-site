# Build

A build is an executable image built from the application’s codebase. It also includes system, language, and application level dependencies and assets.

## Create

Create a new build

```shell
$ curl -X POST --data "stage=0&url=https%3A%2F%2Fgithub.com%2Fexample%2Fexample.git" $RACK_URL/apps/example/builds
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  buildOptions := types.BuildCreateOptions{
    Stage: 0
  }

  build, err := rack.BuildCreate("example", 
                                 "https://github.com/example/example.git",
                                 buildOptions)
}
```

### Request

`POST /apps/example/builds`

### Parameters

Parameter | Default | Required | Description
--------- | ------- | -------- | -----------
**stage** | 0       | no       | 0=prod, 1=dev, 2=test
**url**   |         | yes      | Source code location 

```shell
{
  "id":"BLLIOBVYUO",
  "app":"example",
  "manifest":"",
  "process":"f9b96f80-1ac2-497c-a724-11b2a368cd01",
  "release":"",
  "status":"created",
  "created":"2017-05-12T21:54:58.438438732Z",
  "started":"0001-01-01T00:00:00Z",
  "ended":"0001-01-01T00:00:00Z"
}
```

```go
&types.Build{
  Id:       "BLLIOBVYUO",
  App:      "example",
  Manifest: "",
  Process:  "f9b96f80-1ac2-497c-a724-11b2a368cd01",
  Release:  "",
  Status:   "created",
  Created:  "2017-05-12T21:54:58.438438732Z",
  Started:  "0001-01-01T00:00:00Z",
  Ended:    "0001-01-01T00:00:00Z"
}
```

### Response

| Parameter | Description
|-----------|------------
| id        | Randomly generated build ID
| app       | Name of the app
| manifest  | App manifest
| process   | Build process ID
| release   | Randomly generated release ID (not available until build finshes)
| status    | Live build status
| created   | Time that the build was created
| started   | Time that the build process started
| ended     | Time that the build process ended

## Get

Fetch info about a build.

```shell
curl $RACK_URL/apps/example/builds/BLLIOBVYUO
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  build, err := rack.BuildGet("example", "BLLIOBVYUO")
}
```

### Request

`GET /apps/example/builds/BLLIOBVYUO`

```shell
{
  "id":"BLLIOBVYUO",
  "app":"example",
  "manifest":"services:\n  web:\n    cdn: ${HOST}\n    port: 3000\n",
  "process":"f9b96f80-1ac2-497c-a724-11b2a368cd01",
  "release":"RQEIKGVYYK",
  "status":"complete",
  "created":"2017-05-12T21:54:58.438438732Z",
  "started":"2017-05-12T21:55:01.34897123ZZ",
  "ended":"2017-05-12T21:55:07.606779458Z"
}
```

```go
&types.Build{
  Id:       "BLLIOBVYUO",
  App:      "example",
  Manifest: "services:\n  web:\n    cdn: ${HOST}\n    port: 3000\n",
  Process:  "f9b96f80-1ac2-497c-a724-11b2a368cd01",
  Release:  "RQEIKGVYYK",
  Status:   "complete",
  Created:  "2017-05-12T21:54:58.438438732Z",
  Started:  "2017-05-12T21:55:01.34897123ZZ",
  Ended:    "2017-05-12T21:55:07.606779458Z"
}
```

### Response

An object with the following fields is returned:

| Parameter | Description
| --------- | -----------
| id        | Randomly generated build ID
| app       | Name of the app
| manifest  | App manifest
| process   | Build process ID
| release   | Release ID
| status    | Live build status
| created   | Time that the build was created
| started   | Time that the build process started
| ended     | Time that the build process ended

## List

List the Builds for an App.

```shell
curl http://example.com/apps/example/builds
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  apps, err := rack.BuildList("example")
}
```

### Request

`GET /apps/example/builds`

```shell
[
  {
    "id":"BLLIOBVYUO",
    "app":"example",
    "manifest":"services:\n  web:\n    cdn: ${HOST}\n    port: 3000\n",
    "process":"f9b96f80-1ac2-497c-a724-11b2a368cd01",
    "release":"RQEIKGVYYK",
    "status":"complete",
    "created":"2017-05-12T21:54:58.438438732Z",
    "started":"2017-05-12T21:55:01.34897123ZZ",
    "ended":"2017-05-12T21:55:07.606779458Z"
  },
  {
    "id":"BSEYVADADM",
    "app":"example",
    "manifest":"services:\n  web:\n    cdn: ${HOST}\n    port: 3000\n",
    "process":"829fa04a-29d4-4d25-be73-e323da3182bb",
    "release":"RTVQJZKWBS",
    "status":"complete",
    "created":"2017-05-12T16:40:02.934529617Z",
    "started":"2017-05-12T16:40:04.973123281Z",
    "ended":"2017-05-12T16:41:13.132322037Z"
  }
]
```

```go
&types.Build{
  Id:       "BLLIOBVYUO",
  App:      "example",
  Manifest: "services:\n  web:\n    cdn: ${HOST}\n    port: 3000\n",
  Process:  "f9b96f80-1ac2-497c-a724-11b2a368cd01",
  Release:  "RQEIKGVYYK",
  Status:   "complete",
  Created:  "2017-05-12T21:54:58.438438732Z",
  Started:  "2017-05-12T21:55:01.34897123ZZ",
  Ended:    "2017-05-12T21:55:07.606779458Z"
}
```

### Response

A list of objects with the following fields is returned:

| Parameter | Description                    |
| --------- | -----------
| id        | Randomly generated build ID
| app       | Name of the app
| manifest  | App manifest
| process   | Build process ID
| release   | Release ID
| status    | Live build status
| created   | Time that the build was created
| started   | Time that the build process started
| ended     | Time that the build process ended

## Logs

Fetch logs for a a build.

```shell
curl $RACK_URL/apps/example/builds/BSEYVADADM/logs
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  logs, err := rack.BuildLogs("example", "BSEYVADADM")
}
```

### Request

`GET /apps/example/builds/BSEYVADADM/logs`

```shell
preparing source
restoring cache
building: .
running: docker build -t 9836064b94124bad54f83c70026dd85fcb8b5a13 /tmp/848723224
Sending build context to Docker daemon  11.23MB
<docker logs>
saving cache
storing artifacts
```

```go
io.Copy(os.Stdout, logs)
```

### Response

The logs are streamed in the HTTP response.

## Update

Update details about a build, such as end time.

```shell
curl -X PUT --data "status=complete" $RACK_URL/apps/example/builds/BSEYVADADM
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  logs, err := rack.BuildUpdate("example", "BSEYVADADM", types.BuildUpdateOptions{
    Status: "complete",
  })
}
```

### Request

`PUT $RACK_URL/apps/example/builds/BSEYVADADM`

### Parameters

| Parameter    | Default   | Required | Description
| ------------ | --------- | -------- | -----------
| **manifest** |           | no       | App manifest
| **release**  |           | no       | Release ID
| **status**   |           | no       | Build status
| **started**  |           | no       | Build process start time
| **ended**    |           | no       | Build process end time

```shell
{
  "id":"BSEYVADADM",
  "app":"example",
  "manifest":"services:\n  web:\n    cdn: ${HOST}\n    port: 3000\n",
  "process":"829fa04a-29d4-4d25-be73-e323da3182bb",
  "release":"RTVQJZKWBS",
  "status":"complete",
  "created":"2017-05-12T16:40:02.934529617Z",
  "started":"2017-05-12T16:40:04.973123281Z",
  "ended":"2017-05-12T16:41:13.132322037Z"
}
```

```go
&types.Build{
  Id:       "BSEYVADADM",
  App:      "example",
  Manifest: "services:\n  web:\n    cdn: ${HOST}\n    port: 3000\n",
  Process:  "829fa04a-29d4-4d25-be73-e323da3182bb",
  Release:  "RTVQJZKWBS",
  Status:   "complete",
  Created:  "2017-05-12T16:40:02.934529617Z",
  Started:  "2017-05-12T16:40:04.973123281Z",
  Ended:    "2017-05-12T16:41:13.132322037Z"
```

### Response

An object with the following fields is returned:

| Parameter | Description                    |
| --------- | -----------
| id        | Randomly generated build ID
| app       | Name of the app
| manifest  | App manifest
| process   | Build process ID
| release   | Release ID
| status    | Live build status
| created   | Time that the build was created
| started   | Time that the build process started
| ended     | Time that the build process ended

