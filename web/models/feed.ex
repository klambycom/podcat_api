defmodule PodcatApi.Feed do
  use PodcatApi.Web, :model

  alias PodcatApi.{User, Subscription}
  alias PodcatApi.Xml
  alias PodcatApi.Xml.ItunesParser.Podcast
  alias PodcatApi.Feed.{Explicit, Item}
  alias PodcatApi.Parser

  @http_client Application.get_env(:podcat_api, :http_client)

  schema "feeds" do
    field :title, :string
    field :subtitle, :string
    field :summary, :string
    field :author, :string
    field :link, :string
    field :description, :string
    field :copyright, :string
    field :image_url, :string
    field :feed_url, :string
    field :block, :boolean, default: false
    field :explicit, Explicit, default: :no

    field :subscriber_count, :integer, virtual: true
    field :subscribed_at, Ecto.DateTime, virtual: true, default: nil

    has_many :subscribers, Subscription
    many_to_many :users, User, join_through: Subscription

    has_many :items, Item

    timestamps
  end

  @required_fields ~w(title author summary feed_url)
  @optional_fields ~w(subtitle link description image_url copyright block explicit)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{})

  def changeset(struct, %Podcast{meta: meta, feed_url: feed_url}),
    do: changeset(
          struct,
          %{
            title: meta.title,
            subtitle: meta.subtitle,
            summary: meta.summary,
            author: meta.author,
            link: meta.link,
            description: meta.description,
            copyright: meta.copyright,
            image_url: meta.image_url,
            block: meta.block,
            explicit: meta.explicit,
            feed_url: feed_url
          }
        )

  def changeset(struct, params),
    do: struct
        |> cast(params, @required_fields, @optional_fields)
        |> unique_constraint(:feed_url, name: :feeds_pkey)
        |> unique_constraint(:feed_url, name: :feeds_feed_url_index)

  @doc """
  Download and parse feed from url.
  """
  def download(%__MODULE__{feed_url: feed_url}), do: download(feed_url)

  def download(url) do
    {:ok, response} = @http_client.get(url)

    xml =
      response.body
      |> Xml.from_string

    case Parser.parse(xml) do
      {:ok, feed} -> %{feed | feed_url: url}
      :error -> nil
    end
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

  def summary(%User{id: user_id}) do
    from f in __MODULE__,
      left_join: u in assoc(f, :users),
      left_join: s in Subscription,
        on: s.user_id == ^user_id and s.feed_id == f.id,
      select: %{f | subscriber_count: count(u.id), subscribed_at: s.inserted_at},
      group_by: [f.id, s.inserted_at]
  end
end
