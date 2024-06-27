import gleam/dynamic.{type DecodeErrors, type Dynamic}
import gleam/json.{type Json}

pub type Todo {
  Todo(id: Int, title: String, completed: Bool)
}

pub fn encode_todo(td: Todo) -> Json {
  json.object([
    #("id", json.int(td.id)),
    #("title", json.string(td.title)),
    #("completed", json.bool(td.completed)),
  ])
}

pub type NewTodo {
  NewTodo(title: String, pippo: String)
}

pub fn decode_new_todo(json: Dynamic) -> Result(NewTodo, DecodeErrors) {
  let decoder =
    dynamic.decode2(
      NewTodo,
      dynamic.field("title", of: dynamic.string),
      dynamic.field("pippo", of: dynamic.string),
    )
  decoder(json)
}
