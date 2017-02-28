# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :curtain_with,
  ecto_repos: [CurtainWith.Repo]

# Configures the endpoint
config :curtain_with, CurtainWith.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yRjdI4wb/OGmdKcfKLVbNFblPYI3gb33M4muX3N4h1jsJvNdbHtnMMyuf3wcZPc0",
  render_errors: [view: CurtainWith.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CurtainWith.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"