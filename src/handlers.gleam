import gleam/http.{Get, Post}
import gleam/string_builder
import wisp.{type Request, type Response}

pub fn home_page(req: Request) -> Response {
  // The home page can only be accessed via GET requests, so this middleware is
  // used to return a 405: Method Not Allowed response for all other methods.
  use <- wisp.require_method(req, Get)

  let html = string_builder.from_string("Hello, Joe!")
  wisp.ok()
  |> wisp.html_body(html)
}

pub fn comments(req: Request) -> Response {
  // This handler for `/comments` can respond to both GET and POST requests,
  // so we pattern match on the method here.
  case req.method {
    Get -> list_comments()
    Post -> create_comment(req)
    _ -> wisp.method_not_allowed([Get, Post])
  }
}

pub fn list_comments() -> Response {
  // In a later example we'll show how to read from a database.
  let html = string_builder.from_string("Comments!")
  wisp.ok()
  |> wisp.html_body(html)
}

pub fn create_comment(_req: Request) -> Response {
  // In a later example we'll show how to parse data from the request body.
  let html = string_builder.from_string("Created")
  wisp.created()
  |> wisp.html_body(html)
}

pub fn show_comment(req: Request, id: String) -> Response {
  use <- wisp.require_method(req, Get)

  // The `id` path parameter has been passed to this function, so we could use
  // it to look up a comment in a database.
  // For now we'll just include in the response body.
  let html = string_builder.from_string("Comment with id " <> id)
  wisp.ok()
  |> wisp.html_body(html)
}
