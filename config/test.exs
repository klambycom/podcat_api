use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :podcat_api, PodcatApi.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :podcat_api, PodcatApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "podcat_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure HTTP client
config :podcat_api, :http_client, PodcatApi.HTTPoisonMock
