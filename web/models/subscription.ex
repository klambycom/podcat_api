defmodule PodcatApi.Subscription do
  use PodcatApi.Web, :model

  alias PodcatApi.{User, Feed, Subscription}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "subscriptions" do
    belongs_to :user, User, type: :binary_id
    belongs_to :feed, Feed

    field :is_subscribed, :boolean, virtual: true, default: false

    timestamps
  end

  @required_fields ~w(user_id feed_id)
  @optional_fields ~w()

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:feed_id)
    |> unique_constraint(:feed, name: :user_id_feed_id, message: "already subscribed")
  end

  @doc """
  Get list of subscriptions belonging to a user. Preload user and feed.
  """
  def from_user(%User{id: user_id}) do
    from s in __MODULE__,
      where: s.user_id == ^user_id,
      preload: [:user, :feed]
  end

  @doc """
  Join a `User` with a `Subscription`-query to set `is_subscribed`.
  """
  def join_user(query, %User{id: current_id}) do
    from s in query,
      left_join: c in Subscription,
        on: c.user_id == ^current_id and c.feed_id == s.feed_id,
      select: %{s | is_subscribed: not is_nil(c.user_id)}
  end

  @doc """
  Get the latest subscribers.
  """
  def latest(limit \\ 5) do
    from s in __MODULE__,
      order_by: [desc: :inserted_at],
      limit: ^limit
  end

  @doc """
  Get all subscriptions from feed id.
  """
  def feed_id(feed_id) do
    from s in __MODULE__,
      where: s.feed_id == ^feed_id
  end
end
