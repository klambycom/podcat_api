# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :reader,
  ecto_repos: [Reader.Repo]

# Configures the endpoint
config :reader, Reader.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cJh9aoIJ+Wt4lNailnyoOnNBwuD11zAlisghKkIXG0tnXAJZQKT5aDMLg8JzwvwP",
  render_errors: [view: Reader.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Reader.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure HTTP client
config :reader, :http_client, HTTPoison

# Configure Guardian
config :guardian, Guardian,
  issuer: "Reader",
  ttl: {30, :days},
  secret_key: "d+cGiffjBJ3lDHWDhHfAW0nNoum6KvpBJwSz84kPn5iKl8jtDKNdDQaVtGJjhjls",
  serializer: Reader.User.Serializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
