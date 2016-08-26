defmodule PodcatApi.Feed.Item do
  use PodcatApi.Web, :model

  alias PodcatApi.Feed
  alias PodcatApi.Feed.{Explicit, Enclosure, Duration}
  alias PodcatApi.Xml.ItunesParser

  @primary_key false
  schema "feed_items" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :guid, :string, primary_key: true

    field :title, :string
    field :published_at, Timex.Ecto.DateTime
    field :author, :string
    field :subtitle, :string
    field :summary, :string
    field :duration, Duration, default: {0, 0, 0}
    field :explicit, Explicit, default: :no
    field :image_url, :string
    field :block, :boolean, default: false

    embeds_one :enclosure, Enclosure

    belongs_to :feed, Feed, primary_key: true

    timestamps
  end

  @required_fields ~w(guid title)
  @optional_fields ~w(published_at author subtitle summary block explicit image_url duration feed_id)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{})

  def changeset(struct, item = %ItunesParser.Item{}) do
    item =
      if struct.enclosure && struct.enclosure.id do
        %{item | enclosure: %{id: struct.enclosure.id, length: item.enclosure.size,
                              type: item.enclosure.type, url: item.enclosure.url}}
      else
        item
      end

    changeset(
      struct,
      %{
        guid: item.guid,
        title: item.title,
        published_at: item.published_at,
        author: item.author,
        subtitle: item.subtitle,
        summary: item.summary,
        duration: item.duration,
        explicit: item.explicit,
        image_url: item.image_url,
        block: item.block,
        enclosure: item.enclosure
      }
    )
  end

  def changeset(struct, params),
    do: struct
        |> cast(params, @required_fields, @optional_fields)
        |> cast_embed(:enclosure, required: true)
        |> unique_constraint(:guid, name: :feeds_pkey)
        |> unique_constraint(:uuid)

  @doc """
  Builds a changeset with feed id and `%ItunesParser.Item{}`.
  """
  def changeset_with_feed(feed_id, item = %ItunesParser.Item{}),
    do: changeset(
          %__MODULE__{},
          %{
            feed_id: feed_id,
            guid: item.guid,
            title: item.title,
            published_at: item.published_at,
            author: item.author,
            subtitle: item.subtitle,
            summary: item.summary,
            duration: item.duration,
            explicit: item.explicit,
            image_url: item.image_url,
            block: item.block,
            enclosure: item.enclosure
          }
        )

  @doc """
  Builds a changeset with feed id and `%ItunesParser.Item{}`.
  """
  def changeset_update(feed_id, item = %ItunesParser.Item{}),
    do: changeset(
          %__MODULE__{},
          %{
            feed_id: feed_id,
            guid: item.guid,
            title: item.title,
            published_at: item.published_at,
            author: item.author,
            subtitle: item.subtitle,
            summary: item.summary,
            duration: item.duration,
            explicit: item.explicit,
            image_url: item.image_url,
            block: item.block,
            enclosure: item.enclosure
          }
        )

  @doc """
  Get items sorted by published at.
  """
  def latest(limit, offset \\ 0),
    do: from i in __MODULE__,
          order_by: [desc: :published_at],
          limit: ^limit,
          offset: ^offset
end
