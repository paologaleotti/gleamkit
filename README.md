# gleamkit

> WIP: Very early development, missing consistency and features

![logo](https://github.com/paologaleotti/gleamkit/assets/45665769/233d9ce2-7331-494c-a8d9-345eaeadcf3a)

This experimental repo is a starter kit for writing **HTTP APIs in Gleam** based on `wisp`, 
aiming to provide a simple and opinionated setup that is **production-ready**
(even though Gleam is still a very cutting edge language).

I am aware that Gleam has the "start simple, refactor later" philosophy (just like Golang).
This starter is inspired by my own [blaze](https://github.com/paologaleotti/blaze), 
only giving the user the essentials for real, production use without going crazy on the structure.

## Features

- Simple, opinionated, production ready structure
- Pattern matching based routing
- Handy body decoding and validation
- Automatic human readable errors on decoding failures
- Custom HTTP API error handling
- Request and reply utilities
- Env variables and app context configuration

## TODO

- [x] Body valiadation
- [x] API error handling
- [ ] Structured logging
- [ ] Early returns for error handling
- [x] Env variables

## Snippets

Body validation with automatic validation errors (found in `common/core` module):

```gleam
pub fn handle_create_todo(req: Request) -> Response {
    // Handy direct decoding with custom error handling
    use new_todo <- decode_body(req, todos.decode_new_todo)

    let res = todos.Todo(4, new_todo.title, False)

    // Reply with status code and JSON data
    reply_data(201, todos.encode_todo(res))
}
```

Easy API custom error handling:

```gleam
pub fn handle_get_todo(_req: Request, id: String) -> Response {
  // Early reply utility function to handle errors
  use todo_id <- unpack_or_reply(int.parse(id), fn(_) {
    // Reply with a detailed API error
    reply_error_detailed(BadRequest, "Invalid todo ID")
  })

  let item = list.find(todos, fn(t) { t.id == todo_id })

  // Match on the result and reply with data or API error
  case item {
    Ok(item) -> reply_data(200, todos.encode_todo(item))
    Error(_) -> reply_error(NotFound)
  }
}

```

Direct method/path routing:

```gleam
pub fn handle_request(req: Request, _ctx: AppContext) -> Response {
  use req <- middleware.default_middleware(req)
  use req <- cors.wisp_middleware(req, default_cors())

  case req.method, wisp.path_segments(req) {
    Get, [] -> ok()
    Get, ["todos"] -> todos.handle_get_todos()
    Post, ["todos"] -> todos.handle_create_todo(req)
    Get, ["todos", id] -> todos.handle_get_todo(req, id)
    _, _ -> route_not_found()
  }
}
```

Default HTTP errors (like NotFound) can be found in `common/errors` module, and you can append a detail message to them using the `reply_error_detailed`  function.

## Build and run

```sh
make  # Build the project
make run   # Run the service
```
