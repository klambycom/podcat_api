ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Reader.Repo, :manual)

Code.load_file("test/httpoison_mock.exs")
