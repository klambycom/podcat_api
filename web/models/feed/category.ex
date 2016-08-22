defmodule Reader.Feed.Category do
  use Reader.Web, :model

  schema "feed_categories" do
    field :title, :string
    field :summary, :string, default: ""
    field :slug, :string
    field :itunes_id, :integer

    belongs_to :parent, __MODULE__
    has_many :children, __MODULE__, foreign_key: :parent_id

    timestamps
  end

  @required_fields ~w(title slug itunes_id)
  @optional_fields ~w(summary parent_id)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
  end

  @doc """
  Create slug from the title.

  ## Example

      iex> Reader.Feed.Category.create_slug("Government &amp; Organizations")
      "government-organizations"
  """
  def create_slug(title),
    do: String.downcase(title)
        |> String.replace(~r/&amp;/, "")
        |> String.replace(~r/[^\w-]+/, "-")
end
