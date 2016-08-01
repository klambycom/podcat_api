defmodule Reader.Subscription do
  use Reader.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "subscriptions" do
    belongs_to :user, Reader.User, type: :binary_id
    belongs_to :feed, Reader.Feed

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
  end

  def user_subs(user_id, feed_id) do
    from s in __MODULE__,
      where: s.user_id == ^user_id and s.feed_id == ^feed_id
  end
end
