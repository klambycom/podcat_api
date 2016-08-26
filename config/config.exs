# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :podcat_api,
  ecto_repos: [PodcatApi.Repo]

# Configures the endpoint
config :podcat_api, PodcatApi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cJh9aoIJ+Wt4lNailnyoOnNBwuD11zAlisghKkIXG0tnXAJZQKT5aDMLg8JzwvwP",
  render_errors: [view: PodcatApi.ErrorView, accepts: ~w(json)],
  pubsub: [name: PodcatApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure HTTP client
config :podcat_api, :http_client, HTTPoison

# Configure parsers
config :podcat_api, :parsers, [PodcatApi.Xml.ItunesParser,
                           PodcatApi.Xml.RSS2Parser]

# Configure Guardian
config :guardian, Guardian,
  issuer: "PodcatApi",
  ttl: {30, :days},
  secret_key: "d+cGiffjBJ3lDHWDhHfAW0nNoum6KvpBJwSz84kPn5iKl8jtDKNdDQaVtGJjhjls",
  serializer: PodcatApi.User.Serializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
