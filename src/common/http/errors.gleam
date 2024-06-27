import gleam/json

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

pub const err_bad_request: ApiError = ApiError(
  400,
  "BAD_REQUEST",
  "The request is invalid",
)

pub const err_unauthorized: ApiError = ApiError(
  401,
  "UNAUTHORIZED",
  "You are not authorized",
)

pub const err_forbidden: ApiError = ApiError(
  403,
  "FORBIDDEN",
  "You are not allowed to access this resource",
)

pub const err_not_found: ApiError = ApiError(
  404,
  "NOT_FOUND",
  "Resource not found",
)

pub const err_conflict: ApiError = ApiError(
  409,
  "CONFLICT",
  "Conflict with resources",
)

pub const err_internal_server_error: ApiError = ApiError(
  500,
  "UNKNOWN_INTERNAL",
  "An internal server error occurred",
)
