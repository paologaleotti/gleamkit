import common/http/core.{decode_body, reply_data, reply_error, reply_list}
import common/http/errors.{err_bad_request, err_not_found}
import common/models/todos
import gleam/int
import gleam/list
import wisp.{type Request, type Response}

const todos: List(todos.Todo) = [
  todos.Todo(1, "Buy milk", False), todos.Todo(2, "Buy eggs", False),
  todos.Todo(3, "Buy bread", False),
]

pub fn handle_get_todos() -> Response {
  let todos = list.map(todos, todos.encode_todo)
  reply_list(200, todos)
}

pub fn handle_create_todo(req: Request) -> Response {
  use new_todo <- decode_body(req, todos.decode_new_todo)
  let res = todos.Todo(4, new_todo.title, False)

  reply_data(201, todos.encode_todo(res))
}

pub fn handle_get_todo(_req: Request, id: String) -> Response {
  case int.parse(id) {
    // TODO how to avoid nesting? how to do early return?
    Ok(todo_id) -> {
      let item = list.find(todos, fn(t) { t.id == todo_id })

      case item {
        Ok(item) -> reply_data(200, todos.encode_todo(item))
        Error(_) -> reply_error(err_not_found)
      }
    }
    Error(_) -> reply_error(err_bad_request)
  }
}
