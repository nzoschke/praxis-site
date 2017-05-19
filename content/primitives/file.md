# File

Files in a process container can be copied in or out during runtime.

## Delete

Delete files from a process’s container filesystem.

```shell
$ curl -X DELETE --data "/usr/local/foo,bar.txt" $RACK_URL/apps/example/processes/web/files
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  files := []string{"/usr/local/foo", "bar.txt"}
  err := rack.FilesDelete("example", "web", "files")
}
```

### Request

`DELETE /apps/example/processes/web/files`

### Response

An empty HTTP response with a status code will be returned.

## Upload

Copy files into a process’s container filesystem.

```shell
$ curl -F 'body=@/usr/local/foo' $RACK_URL/apps/example/processes/web/files
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  file, _ := os.Open("/usr/local/boo")
  err := rack.FilesUpload("example", "web", "file")
}
```

### Request

`POST /apps/example/processes/web/files`

### Response

An empty HTTP response with a status code will be returned.

