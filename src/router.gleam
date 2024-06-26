import common/http/core
import gleam/http.{Get, Post}
import handlers
import wisp.{type Request, type Response, not_found, ok}

pub fn handle_request(req: Request) -> Response {
  use req <- core.middleware(req)

  case wisp.path_segments(req) {
    [] -> {
      case req.method {
        Get -> ok()
        _ -> not_found()
      }
    }
    ["comments"] -> {
      case req.method {
        Get -> handlers.list_comments()
        Post -> handlers.create_comment(req)
        _ -> not_found()
      }
    }
    ["comments", id] -> {
      case req.method {
        Get -> handlers.show_comment(req, id)
        _ -> not_found()
      }
    }
    _ -> not_found()
  }
}
