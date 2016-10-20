defmodule PodcatApi.PlaylistItem do
  use PodcatApi.Web, :model

  alias PodcatApi.{User, Feed}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "playlist_items" do
    field :automatically_added, :boolean, default: false

    belongs_to :user, User, type: :binary_id
    belongs_to :feed_item, Feed.Item, references: :uuid, type: Ecto.UUID

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:automatically_added, :user_id, :feed_item_id])
    |> validate_required([:automatically_added, :user_id, :feed_item_id])
  end

  @doc """
  Filter out automatically added playlist items or just playlist items
  added by the user.
  """
  def filter(limit, offset, auto \\ false) do
    from p in __MODULE__,
      where: p.automatically_added == ^auto,
      join: u in assoc(p, :user),
      join: i in assoc(p, :feed_item),
        join: f in assoc(i, :feed),
      limit: ^limit,
      offset: ^offset,
      preload: [user: u, feed_item: {i, feed: f}]
  end
end
