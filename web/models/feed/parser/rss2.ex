defmodule Reader.Feed.Parser.RSS2 do
  alias Reader.Xml

  @doc """
  Check if the XML-document is in the RSS2-format.

  ## Example

      iex> Reader.Xml.from_string("<channel><title>Klamby Blog</title></channel>")
      ...> |> Reader.Feed.Parser.RSS2.valid?
      false

      iex> Reader.Xml.from_string(
      ...>   \"\"\"
      ...>   <?xml version="1.0" encoding="UTF-8" ?>
      ...>   <rss version="2.0">
      ...>     <channel><title>Klamby Blog</title></channel>
      ...>   </rss>
      ...>   \"\"\"
      ...> )
      ...> |> Reader.Feed.Parser.RSS2.valid?
      true
  """
  def valid?(document),
    do: document
        |> Xml.xpath("/rss")
        |> Xml.attr("version") == "2.0"

  @doc """
  ## Example

      iex> Reader.Xml.from_string(
      ...>   \"\"\"
      ...>   <?xml version="1.0" encoding="UTF-8" ?>
      ...>   <rss version="2.0">
      ...>     <channel>
      ...>       <title>Klamby Blog</title>
      ...>       <description>Klamby Awesome Blog</description>
      ...>       <link>https://klamby.com</link>
      ...>     </channel>
      ...>   </rss>
      ...>   \"\"\"
      ...> )
      ...> |> Reader.Feed.Parser.RSS2.parse
      %{
        title: "Klamby Blog",
        homepage: "https://klamby.com",
        description: "Klamby Awesome Blog",
        feed_url: nil
      }
  """
  def parse(document) do
    %{
          summary: document |> channel("./title") |> Xml.text,
          homepage: document |> channel("./link") |> Xml.text,
          description: document |> channel("./description") |> Xml.text,
          feed_url: nil
        }
  end

  defp channel(document, path), do: document |> Xml.xpath("/rss/channel") |> Xml.xpath(path)
end
