import common/http/utils.{get_env_or_panic}

type Env {
  Env(enviroment: String)
}

/// AppContext holds the shared context for the application
/// between handlers, for example a database connection.
pub type AppContext {
  AppContext(db: String)
}

fn get_env_vars() -> Env {
  Env(enviroment: get_env_or_panic("ENVIRONMENT"))
}

pub fn init_context() -> AppContext {
  // let env = get_env_vars() // get typed env vars
  AppContext(db: "db")
}
// TODO finish this, adding a real db connection
