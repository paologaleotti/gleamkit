import common/http/core
import handlers
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  use req <- core.middleware(req)

  case wisp.path_segments(req) {
    [] -> handlers.home_page(req)
    ["comments"] -> handlers.comments(req)
    ["comments", id] -> handlers.show_comment(req, id)
    _ -> wisp.not_found()
  }
}
