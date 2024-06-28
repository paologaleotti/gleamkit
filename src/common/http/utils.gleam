import gleam/erlang/os

/// get_env_or_panic returns the value of an environment variable or panics if it's not set.
/// This is useful for configuration values that are required for the application to run.
pub fn get_env_or_panic(key: String) -> String {
  case os.get_env(key) {
    Ok(k) -> k
    Error(_) -> panic as { "Environment variable not set: " <> key }
  }
}
