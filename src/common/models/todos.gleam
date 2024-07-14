import decode
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
  NewTodo(title: String)
}

pub fn decode_new_todo(input: Dynamic) -> Result(NewTodo, DecodeErrors) {
  decode.into({
    use title <- decode.parameter
    NewTodo(title)
  })
  |> decode.field("title", decode.string)
  |> decode.from(input)
}
