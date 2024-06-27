import common/http/errors.{
  type ApiError, err_bad_request, err_not_found, with_detail,
}
import gleam/dynamic
import gleam/json
import gleam/list
import gleam/string
import wisp

pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)

  handle_request(req)
}

/// reply_data returns a Response with generic JSON data
pub fn reply_data(status: Int, data: json.Json) -> wisp.Response {
  wisp.json_response(json.to_string_builder(data), status)
}

/// reply_list returns a Response with a JSON array of items
pub fn reply_list(status: Int, items: List(json.Json)) -> wisp.Response {
  let data = json.preprocessed_array(items)
  wisp.json_response(json.to_string_builder(data), status)
}

/// reply_error encodes an ApiError as JSON and returns a Response
pub fn reply_error(error: ApiError) -> wisp.Response {
  let err = errors.encode_error(error)
  wisp.json_response(json.to_string_builder(err), error.status)
}

pub fn route_not_found() -> wisp.Response {
  let err = errors.with_detail(err_not_found, "Route not found")
  let encoded = errors.encode_error(err)
  wisp.json_response(json.to_string_builder(encoded), 404)
}

/// decode_body decodes the JSON body directly into a type using the provided decoder.
/// If the decoding fails, it replies with a 400 Bad Request ApiError.
pub fn decode_body(
  request: wisp.Request,
  decoder: fn(dynamic.Dynamic) -> Result(a, dynamic.DecodeErrors),
  next: fn(a) -> wisp.Response,
) -> wisp.Response {
  use body <- wisp.require_json(request)

  let decoded = decoder(body)
  case decoded {
    Ok(data) -> next(data)
    Error(errors) -> {
      let msg = format_decode_error(errors)
      reply_error(with_detail(err_bad_request, msg))
    }
  }
}

fn format_decode_error(errors: dynamic.DecodeErrors) -> String {
  list.map(errors, fn(e) {
    "Expected "
    <> e.expected
    <> " "
    <> string.join(e.path, "->")
    <> "; provided: "
    <> e.found
  })
  |> string.join(". ")
}
