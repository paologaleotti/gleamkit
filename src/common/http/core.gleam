import common/http/errors.{with_detail}
import gleam/dynamic
import gleam/json
import gleam/list
import gleam/string
import wisp

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
pub fn reply_error(error: errors.HttpError) -> wisp.Response {
  let api_err = errors.error_to_api(error)
  let err = errors.encode_error(api_err)
  wisp.json_response(json.to_string_builder(err), api_err.status)
}

/// reply_error_detailed appends a detail message to an ApiError and returns a Response
pub fn reply_error_detailed(
  error: errors.HttpError,
  detail: String,
) -> wisp.Response {
  let api_err = errors.error_to_api(error)
  let err = errors.encode_error(with_detail(api_err, detail))
  wisp.json_response(json.to_string_builder(err), api_err.status)
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
      reply_error_detailed(errors.BadRequest, msg)
    }
  }
}

/// unpack_or_reply works as an early return for errors. 
/// It matches the provided Result and if it's an Error it
/// calls the callback passing the error as an argument.
/// 
/// If possible, avoid abusing this function 
/// as it can make the code less functional-style and harder to read.
pub fn unpack_or_reply(
  res: Result(a, e),
  callback: fn(e) -> reply,
  next: fn(a) -> reply,
) -> reply {
  case res {
    Ok(data) -> next(data)
    Error(e) -> callback(e)
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
