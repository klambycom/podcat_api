defmodule Reader.Feed do
  use Reader.Web, :model

  schema "feeds" do
    field :name, :string
    field :homepage, :string
    field :description, :string
    field :rss_feed, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :homepage, :description, :rss_feed])
    |> validate_required([:name, :homepage, :description, :rss_feed])
  end
end
