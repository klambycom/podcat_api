defmodule PodcatApi.User do
  use PodcatApi.Web, :model

  alias PodcatApi.{Feed, Subscription}

  @email_regex ~r/\S+@\S+\.\S+/

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_digest, :string
    field :password, :string, virtual: true

    many_to_many :subscriptions, Feed, join_through: Subscription

    timestamps
  end

  @required_fields ~w(email password)
  @optional_fields ~w(name)

  @doc """
  Create a changeset based on the `model` and `params`. And hash the password.
  """
  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, @email_regex)
    |> unique_constraint(:email)
    |> put_pass_hash
  end

  @doc """
  Create login changeset with just email and password.
  """
  def login_changeset(model, params \\ :invalid) do
    model
    |> cast(params, ~w(email password), ~w())
    |> validate_format(:email, @email_regex)
  end

  @doc """
  Find user by email.
  """
  def find_by_email(email) do
    from a in __MODULE__,
    where: a.email == ^email
  end

  @doc """
  Get user and subscriptions.
  """
  def subscriptions do
    from u in __MODULE__,
      preload: :subscriptions
  end

  defp put_pass_hash(changeset) do
    if Map.has_key?(changeset.changes, :password) do
      password = changeset.changes.password
      put_change(changeset, :password_digest, Comeonin.Bcrypt.hashpwsalt(password))
    else
      changeset
    end
  end
end
