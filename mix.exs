defmodule PodcatApi.Mixfile do
  use Mix.Project

  def project do
    [app: :podcat_api,
     version: "0.2.4",
     name: "Podcat API",
     homepage_url: "http://podcat.ninja",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {PodcatApi, []},
      applications: [
        :phoenix,
        :phoenix_pubsub,
        :cowboy,
        :logger,
        :gettext,
        :phoenix_ecto,
        :postgrex,
        :httpoison,
        :comeonin,
        :timex,
        :timex_ecto,
        :corsica,
        :poolboy,
        :guardian,
        :mogrify,
        :edeliver,
        :absinthe_relay
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.2.1"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:httpoison, "~> 0.9.0"},
      {:comeonin, "~> 2.5"},
      {:guardian, "~> 0.12.0"},
      {:poison, "~> 2.0"},
      {:mogrify, "~> 0.3.3"},
      {:timex, "~> 3.0"},
      {:timex_ecto, "~> 3.0"},
      {:ex_doc, "~> 0.12", only: :dev},
      {:corsica, "~> 0.4"},
      {:poolboy, "~> 1.5"},
      {:distillery, "~> 0.10.1", warn_missing: false},
      {:edeliver, "~> 1.4.0"},
      {:absinthe_plug, "~> 1.1"},
      {:logger_file_backend, "~> 0.0.9"},
      {:absinthe_relay, "~> 0.9.2"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
