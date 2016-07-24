use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :reader, Reader.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :reader, Reader.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "dev",
  password: "",
  database: "reader_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure HTTP client
config :reader, :http_client, Reader.HTTPoisonMock
