defmodule PodcatApi.HTTPoisonMock do
  def get!("https://itunes.apple.com/search?" <> _rest) do
    {:ok, body} = read_file("itunes_search_result.json")
    body
  end

  def get(url) do
    [_, file] = Regex.run(~r/https?:\/\/\S*\/(\S*)/, url)
    read_file(file)
  end

  defp read_file(filename) do
    case File.read("test/fixtures/#{filename}") do
      {:ok, body} -> {:ok, %{body: body}}
      {:error, _} -> nil # TODO Should probably test 404
    end
  end
end
