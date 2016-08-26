defmodule PodcatApi.HTTPoisonMock do
  def get(url) do
    [_, file] = Regex.run(~r/https?:\/\/\S*\/(\S*)/, url)

    case File.read("test/fixtures/#{file}") do
      {:ok, body} -> {:ok, %{body: body}}
      {:error, _} -> nil # TODO Should probably test 404
    end
  end
end
