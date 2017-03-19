# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :curtain_with,
  api_key: System.get_env("API_KEY"),
  ecto_repos: [CurtainWith.Repo]

# Configures the endpoint
config :curtain_with, CurtainWith.Endpoint,
  render_errors: [view: CurtainWith.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CurtainWith.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :curtain_with, CurtainWith.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "18")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
