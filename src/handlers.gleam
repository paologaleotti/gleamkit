import gleam/string_builder
import wisp.{type Request, type Response, ok}

pub fn list_comments() -> Response {
  let html = string_builder.from_string("Comments!")
  ok()
  |> wisp.html_body(html)
}

pub fn create_comment(_req: Request) -> Response {
  let html = string_builder.from_string("Created")
  wisp.created()
  |> wisp.html_body(html)
}

pub fn show_comment(_req: Request, id: String) -> Response {
  let html = string_builder.from_string("Comment with id " <> id)
  ok()
  |> wisp.html_body(html)
}
