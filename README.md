# gleamkit

> WIP: Very early development, missing consistency and features

This experimental repo is a starter kit for writing **HTTP APIs in Gleam** based on `wisp`, 
aiming to provide a simple and opinionated setup that is **production-ready**
(even though Gleam is still a very cutting edge language)

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
    let item = list.find(todos, fn(t) { t.id == todo_id })

    // Match on the result and reply with data or API error
    case item {
        Ok(item) -> reply_data(200, todos.encode_todo(item))
        Error(_) -> reply_error(err_not_found)
    }
}

```

Default errors (like err_not_found) can be found in `common/errors` module, and you can append a detail message to them using the `with_detail`  function.

## Build and run

```sh
gleam build  # Build the project
gleam run   # Run the service
```
