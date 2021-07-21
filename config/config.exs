# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :dream_up,
  ecto_repos: [DreamUp.Repo]

# Configures the endpoint
config :dream_up, DreamUpWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rOte6sV+D57HeHXVi6LYLKz6NeITNGWPhgAPIjK2cK8dxfOg4Hh2qAO/Vpb7y4+r",
  render_errors: [view: DreamUpWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: DreamUp.PubSub,
  live_view: [signing_salt: "4kxFWBWI"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
