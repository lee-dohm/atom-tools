# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :atom_tools,
  ecto_repos: [AtomTools.Repo]

# Configures the endpoint
config :atom_tools, AtomTools.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MaxliNGpocp+n20SpTKwaR3VgloqV70Z+NGRwwL1Z5dxgqB8XwW4TXF6lDIEqqpW",
  render_errors: [view: AtomTools.ErrorView, accepts: ~w(html json)],
  pubsub: [name: AtomTools.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
