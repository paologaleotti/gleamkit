import common/http/core.{reply_error}
import common/http/errors.{err_not_found}
import gleam/string_builder
import wisp.{type Request, type Response, ok}

// TODO WIP

pub fn list_comments() -> Response {
  reply_error(err_not_found)
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
