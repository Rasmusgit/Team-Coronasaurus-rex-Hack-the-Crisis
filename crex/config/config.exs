# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :crex, CrexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "k5NA1uN51J6u3Es2m8QVSPxpSRvqdmzbfNJCk5BgI+Jy+ypgRLJDGuD0qpRp+opg",
  render_errors: [view: CrexWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Crex.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "XMvlGzai"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
config :crex, Crex.Mailer, adapter: Swoosh.Adapters.Local
import_config "#{Mix.env()}.exs"
