# Cache

A key/value store. Items may be given a custom expiration.

## Fetch

Get the value for a given key.

```shell
$ curl $RACK_URL/apps/example/caches/mycache/mykey
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  val, err := rack.CacheFetch("example", "mycache", "mykey")
}
```

### Request

`GET /apps/example/caches/mycache/mykey`

### Response

```shell
{
  "baz":"qux",
  "foo":"bar"
}
```

```go
map[foo:bar baz:qux]
```

A map object is returned.

## Store

Set a key/value pair and its expiration.

```shell
$ curl -X POST --data "foo=bar&baz=qux" $RACK_URL/apps/example/caches/mycache/mykey
```

```go
package main

import "github.com/convox/praxis/sdk/rack"

func main() {
  attrs := map[string]string{
    "foo": "bar",
    "baz": "qux",
  }

  // 1-hour TTL
  options = types.CacheStoreOptions{
    Expires: 3600
  }

  err := rack.CacheFetch("example", "mycache", "mykey", attrs, options)
}
```

### Request

`POST $RACK_URL/apps/example/caches/mycache/mykey`

### Parameters

A map of string to string should be sent as post data.

### Response

An empty HTTP response with a status code will be returned.
