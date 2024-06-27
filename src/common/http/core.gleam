import common/http/errors.{type ApiError, err_not_found}
import gleam/json
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
