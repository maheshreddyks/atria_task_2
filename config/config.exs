# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :atria_task_2,
  ecto_repos: [AtriaTask2.Repo]

# Configures the endpoint
config :atria_task_2, AtriaTask2Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "urG2Zpk0npXMHuEm/wL6U/LJgahq8l3MSxAH0zHG10pcX/hVmdPOeZDayVA861mL",
  render_errors: [view: AtriaTask2Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: AtriaTask2.PubSub,
  live_view: [signing_salt: "C8LbwN5W"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
