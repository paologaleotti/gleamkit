import common/http/core.{route_not_found}
import config.{type AppContext}
import gleam/http.{Get, Post}
import handlers/todos
import wisp.{type Request, type Response, ok}

pub fn handle_request(req: Request, _ctx: AppContext) -> Response {
  use req <- core.middleware(req)

  case wisp.path_segments(req) {
    [] -> {
      case req.method {
        Get -> ok()
        _ -> route_not_found()
      }
    }
    ["todos"] -> {
      case req.method {
        Get -> todos.handle_get_todos()
        Post -> todos.handle_create_todo(req)
        _ -> route_not_found()
      }
    }
    ["todos", id] -> {
      case req.method {
        Get -> todos.handle_get_todo(req, id)
        _ -> route_not_found()
      }
    }
    _ -> route_not_found()
  }
}
