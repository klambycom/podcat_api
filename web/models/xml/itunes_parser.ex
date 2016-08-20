defmodule Reader.Xml.ItunesParser do
  @behaviour Reader.Parser

  alias Reader.Xml

  defmodule Podcast do
    defstruct meta: nil, items: [], feed_url: nil
  end

  defmodule Meta do
    @modeledoc """
    Meta contains information about the podcast.

    Summary is the value of <itunes:summary>, or <description> if summary is
    missing.
    """

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

    @doc """
    Parse data about the podcast.
    """
    def parse(document),
      do: %__MODULE__{
            title: document |> Xml.xpath("./title") |> Xml.text,
            subtitle: document |> Xml.xpath("./itunes:subtitle") |> Xml.text,
            summary: Xml.ItunesParser.one_of([
              document |> Xml.xpath("./itunes:summary") |> Xml.text,
              document |> Xml.xpath("./description") |> Xml.text
            ]),
            author: document |> Xml.xpath("./itunes:author") |> Xml.text,
            link: document |> Xml.xpath("./link") |> Xml.text,
            description: document |> Xml.xpath("./description") |> Xml.text,
            copyright: document |> Xml.xpath("./copyright") |> Xml.text,
            image_url: document |> Xml.xpath("./itunes:image") |> Xml.attr("href"),
            block: document |> Xml.ItunesParser.is_blocked,
            explicit: document |> Xml.xpath("./itunes:explicit") |> Xml.text
          }
  end

  defmodule Item do
    @modeledoc """
    Item is the episodes from the podcast.
    """

    defstruct guid: nil,
              title: nil,
              subtitle: nil,
              summary: nil,
              author: nil,
              duration: nil,
              published_at: nil,
              image_url: nil,
              explicit: nil,
              block: false,
              enclosure: nil

    @doc """
    Parse a item in the feed.
    """
    def parse(document),
      do: %__MODULE__{
            guid: Xml.ItunesParser.one_of([
              document |> Xml.xpath("./guid") |> Xml.text,
              document |> Xml.xpath("./link") |> Xml.text
            ]),
            title: document |> Xml.xpath("./title") |> Xml.text,
            published_at: rss_date(document |> Xml.xpath("./pubDate") |> Xml.text),
            author: document |> Xml.xpath("./itunes:author") |> Xml.text,
            duration: document |> Xml.xpath("./itunes:duration") |> Xml.text,
            subtitle: document |> Xml.xpath("./itunes:subtitle") |> Xml.text,
            summary: Xml.ItunesParser.one_of([
              document |> Xml.xpath("./itunes:summary") |> Xml.text,
              document |> Xml.xpath("./description") |> Xml.text
            ]),
            image_url: document |> Xml.xpath("./itunes:image") |> Xml.attr("href"),
            block: document |> Xml.ItunesParser.is_blocked,
            explicit: document |> Xml.xpath("./itunes:explicit") |> Xml.text,
            enclosure: Xml.ItunesParser.Enclosure.parse(document)
          }

    defp rss_date(nil), do: nil
    defp rss_date(date), do: Reader.DateUtils.RFC2822.parse(date)
  end

  defmodule Enclosure do
    @modeledoc """
    Audio for the episode/item. The enclosure contains the attached multimedia
    to the item by providing the URL of the file and not the actual file.
    """

    defstruct url: nil, size: 0, type: nil

    @doc """
    The enclosure contains the url, size in bytes and the mime type.
    """
    def parse(document),
      do: %__MODULE__{
            url: document |> Xml.xpath("./enclosure") |> Xml.attr("url"),
            size: document |> Xml.xpath("./enclosure") |> Xml.attr("length"),
            type: document |> Xml.xpath("./enclosure") |> Xml.attr("type")
          }
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
          meta: document |> Xml.xpath("/rss/channel") |> Meta.parse,
          items: document |> Xml.xpath("/rss/channel/item") |> Enum.map(&Item.parse/1)
        }

  @doc """
  Check if document (feed or item) is blocked and should not be visible.
  """
  def is_blocked(document) do
    value = document
            |> Xml.xpath("./itunes:block")
            |> Xml.text

    is_binary(value) && String.downcase(value) == "yes"
  end

  @doc """
  Get first value that is not nil.
  """
  def one_of(values),
    do: Enum.find(values, nil, fn(value) -> not is_nil(value) end)
end
