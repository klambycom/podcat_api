defmodule Reader.Search do
  defstruct title: "", author: "", genre_ids: [], feed_url: "", image_url: ""

  @http_client Application.get_env(:reader, :http_client)

  def itunes(term, limit \\ 50) do
    response =
      %{"term" => term, "limit" => limit, "lang" => "en_us", "media" => "podcast"}
      |> get_itunes_url
      |> @http_client.get!
      |> Map.get(:body)
      |> Poison.Parser.parse!

    response["results"]
    |> Enum.map(&itunes_result_to_search/1)
  end

  defp get_itunes_url(params),
    do: "https://itunes.apple.com/search?" <> URI.encode_query(params)

  defp itunes_result_to_search(%{
    "trackName" => title,
    "artistName" => author,
    "genreIds" => genre_ids,
    "feedUrl" => feed_url,
    "artworkUrl100" => image_url
  }),
    do: %__MODULE__{
      title: title,
      author: author,
      genre_ids: genre_ids,
      feed_url: feed_url,
      image_url: image_url
    }
end
