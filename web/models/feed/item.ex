defmodule Reader.Feed.Item do
  use Reader.Web, :model

  alias Reader.Feed
  alias Reader.Feed.{Explicit, Enclosure, Duration}

  @primary_key false
  schema "feed_items" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :guid, :string, primary_key: true

    field :title, :string
    field :published_at, Ecto.DateTime
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
  @optional_fields ~w(published_at author subtitle summary block explicit image_url duration)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}),
    do: struct
        |> cast(params, @required_fields, @optional_fields)
        |> cast_embed(:enclosure, required: true)
        |> unique_constraint(:guid, name: :feeds_pkey)
        |> unique_constraint(:uuid)
end
