defmodule PodcatApi.Resolver.User do
  alias PodcatApi.{Repo, User, Subscription}

  @doc """
  Find user from id, current user or subscription. Return a
  empty user if no id is provided and the user is not signed
  in.
  """
  def find(%{id: id}, _) do
    case Repo.get(User, id) do
      nil  -> {:error, "User id #{id} not found"}
      user -> {:ok, user}
    end
  end

  def find(%{}, %{source: %Subscription{} = subscription}),
    do: {:ok, subscription.user}

  def find(%{}, %{context: %{conn: conn}}) do
    case Guardian.Plug.current_resource(conn) do
      nil  -> {:ok, %User{id: 0}}
      user -> {:ok, user}
    end
  end

  @doc """
  Avatar from gravatar. Empty string if the user is empty
  (or not signed in).
  """
  def image(%{size: size}, %{source: user}) do
    case user.id do
      0 -> {:ok, ""}
      _ -> {:ok, User.gravatar_url(user, size)}
    end
  end
end
