/// AppContext holds the shared context for the application
/// between handlers, for example a database connection.
pub type AppContext {
  AppContext(db: String)
}

/// init_context creates a new AppContext,
/// crashing the program if something fails to initialize.
pub fn init_context() -> AppContext {
  AppContext(db: "db")
}
// TODO finish this, adding a real db connection
