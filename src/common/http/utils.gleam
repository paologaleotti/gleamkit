import common/http/core
import common/http/errors
import cors_builder as cors
import gleam/erlang/os
import gleam/http
import wisp

/// get_env_or_panic returns the value of an environment variable or panics if it's not set.
/// This is useful for configuration values that are required for the application to run.
pub fn get_env_or_panic(key: String) -> String {
  case os.get_env(key) {
    Ok(k) -> k
    Error(_) -> panic as { "Environment variable not set: " <> key }
  }
}

/// permissive CORS configuration
pub fn default_cors() {
  cors.new()
  |> cors.allow_all_origins()
  |> cors.allow_credentials()
  |> cors.allow_header("*")
  |> cors.allow_method(http.Get)
  |> cors.allow_method(http.Post)
  |> cors.allow_method(http.Put)
  |> cors.allow_method(http.Patch)
  |> cors.allow_method(http.Delete)
  |> cors.allow_method(http.Options)
}

/// route_not_found returns a 404 Not Found with detailed error message
pub fn route_not_found() -> wisp.Response {
  core.reply_error_detailed(errors.NotFound, "Route not found")
}
