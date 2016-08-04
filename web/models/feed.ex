defmodule Reader.Feed do
  use Reader.Web, :model

  alias Reader.Xml
  alias Reader.Feed.Parser.RSS2

  @http_client Application.get_env(:reader, :http_client)

  schema "feeds" do
    field :summary, :string
    field :author, :string
    field :homepage, :string
    field :description, :string
    field :image_url, :string
    field :feed_url, :string
    field :subscriber_count, :integer, virtual: true
    field :subscribed_at, Ecto.DateTime, virtual: true, default: nil

    many_to_many :users, Reader.User, join_through: Reader.Subscription

    timestamps
  end

  @required_fields ~w(summary feed_url)
  @optional_fields ~w(author homepage description image_url)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:feed_url)
  end

  @doc """
  Download and parse feed from url.
  """
  def download(url) do
    {:ok, response} = @http_client.get(url)

    feed =
      response.body
      |> Xml.from_string
      |> RSS2.parse

    %{feed | feed_url: url}
  end

  @doc """
  Get summary of the feed, with number of subscribers.
  """
  def summary do
    from f in __MODULE__,
      left_join: u in assoc(f, :users),
      select: %{f | subscriber_count: count(u.id)},
      group_by: f.id
  end

  def summary(%Reader.User{id: user_id}) do
    from f in __MODULE__,
      left_join: u in assoc(f, :users),
      left_join: s in Reader.Subscription,
        on: s.user_id == ^user_id and s.feed_id == f.id,
      select: %{f | subscriber_count: count(u.id), subscribed_at: s.inserted_at},
      group_by: [f.id, s.inserted_at]
  end
end
