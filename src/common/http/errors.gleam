import gleam/json

pub type HttpError {
  BadRequest
  Unauthorized
  Forbidden
  NotFound
  Conflict
  UnkownInternal
}

pub fn error_to_api(err: HttpError) -> ApiError {
  case err {
    BadRequest -> ApiError(400, "BAD_REQUEST", "The request is invalid")
    Unauthorized -> ApiError(401, "UNAUTHORIZED", "You are not authorized")
    Forbidden ->
      ApiError(403, "FORBIDDEN", "You are not allowed to access this resource")
    NotFound -> ApiError(404, "NOT_FOUND", "Resource not found")
    Conflict -> ApiError(409, "CONFLICT", "Conflict with resources")
    UnkownInternal ->
      ApiError(500, "UNKNOWN_INTERNAL", "An internal server error occurred")
  }
}

/// ApiError represents an error that can be returned by the HTTP API.
pub type ApiError {
  ApiError(status: Int, code: String, message: String)
}

pub fn encode_error(error: ApiError) -> json.Json {
  json.object([
    #("status", json.int(error.status)),
    #("code", json.string(error.code)),
    #("message", json.string(error.message)),
  ])
}

/// with_detail returns a new ApiError with the given detail message attached.
pub fn with_detail(err: ApiError, detail: String) -> ApiError {
  ApiError(err.status, err.code, err.message <> ": " <> detail)
}
