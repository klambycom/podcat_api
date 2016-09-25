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
end
