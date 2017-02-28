use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :curtain_with, CurtainWith.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :curtain_with, CurtainWith.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "curtain_with_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
