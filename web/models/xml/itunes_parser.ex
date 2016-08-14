defmodule Reader.Xml.ItunesParser do
  alias Reader.Xml

  defmodule Podcast do
    defstruct meta: nil, items: [], feed_url: nil
  end

  defmodule Meta do
    defstruct title: nil,
              subtitle: nil,
              summary: nil,
              author: nil,
              link: nil,
              description: nil, # TODO Remove?
              copyright: nil,
              image_url: nil,
              block: false,
              explicit: nil
  end

  defmodule Item do
    defstruct guid: nil # Link if guid is missing, I tink.
  end

  defmodule Enclosure do
    defstruct url: nil, duration: 0, type: nil
  end

  @doc """
  Check if the document is a RSS-feed for Itunes.

  ## Example

      iex> Reader.Xml.from_string(
      ...>   \"\"\"
      ...>   <?xml version="1.0" encoding="UTF-8" ?>
      ...>   <rss xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" version="2.0">
      ...>     <channel>
      ...>       <title>Klamby Podcast</title>
      ...>       <itunes:subtitle>Klamby Podcast!</itunes:subtitle>
      ...>     </channel>
      ...>   </rss>
      ...>   \"\"\"
      ...> )
      ...> |> Reader.Xml.ItunesParser.valid?
      true
  """
  def valid?(document) do
    rss =
      document
      |> Xml.xpath("/rss")
      |> Xml.attr("version") == "2.0"

    itunes =
      document
      |> Xml.namespace?(:itunes)

    rss && itunes
  end

  @doc """
  Parse both meta-data and items.
  """
  def parse(document),
    do: %__MODULE__.Podcast{
          meta: meta(document)
        }

  @doc """
  Parse data about the podcast.
  """
  def meta(document),
    do: %__MODULE__.Meta{
          title: document |> channel("./title") |> Xml.text,
          subtitle: document |> channel("./itunes:subtitle") |> Xml.text,
          summary: document |> channel("./itunes:summary") |> Xml.text,
          author: document |> channel("./itunes:author") |> Xml.text,
          link: document |> channel("./link") |> Xml.text,
          description: document |> channel("./description") |> Xml.text,
          copyright: document |> channel("./copyright") |> Xml.text,
          image_url: document |> channel("./itunes:image") |> Xml.attr("href"),
          block: document |> channel("./itunes:block") |> Xml.text |> is_blocked,
          explicit: document |> channel("./itunes:explicit") |> Xml.text
        }
        |> update_summary
  #field :explicit, Explicit, default: :no

  # If <itunes:summary> is not included, the contents of the <description> tag are used.
  # http://lists.apple.com/archives/syndication-dev/2005/Nov/msg00002.html#_Toc526931691
  defp update_summary(meta) do
    if is_nil(meta.summary) do
      %{meta | summary: meta.description}
    else
      meta
    end
  end

  defp is_blocked(str), do: is_binary(str) && String.downcase(str) == "yes"

  defp channel(document, path), do: document |> Xml.xpath("/rss/channel") |> Xml.xpath(path)
end
