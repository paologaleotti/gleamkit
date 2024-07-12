import common/http/middleware
import common/http/utils.{default_cors, route_not_found}
import config.{type AppContext}
import cors_builder as cors
import gleam/http.{Get, Post}
import handlers/todos
import wisp.{type Request, type Response, ok}

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
