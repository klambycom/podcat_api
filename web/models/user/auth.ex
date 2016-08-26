defmodule PodcatApi.User.Auth do
  @modeledoc """
  Authenticate the user with password.
  """

  alias PodcatApi.{Repo, User}
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  @doc """
  Find user by email and verify that the password is correct.
  """
  def verify(user_params) do
    changeset = User.login_changeset(%User{}, user_params)

    if changeset.valid? do
      changeset.changes.email
      |> User.find_by_email
      |> Repo.one
      |> check_password(changeset)
    else
      {:error, changeset}
    end
  end

  defp check_password(user, changeset) do
    cond do
      user && checkpw(changeset.changes.password, user.password_digest) ->
        {:ok, user}
      user ->
        {:error, Ecto.Changeset.add_error(changeset, :login, "bad password")}
      true ->
        dummy_checkpw
        {:error, Ecto.Changeset.add_error(changeset, :login, "not found")}
    end
  end
end
