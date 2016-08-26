ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(PodcatApi.Repo, :manual)

Code.load_file("test/httpoison_mock.exs")
