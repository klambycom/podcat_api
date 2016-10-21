defmodule PodcatApi.Resolver.User do
  alias PodcatApi.{Repo, User, Subscription}

  @doc """
  Find user from id, current user or subscription.
  """
  def find(%{id: id}, _) do
    case Repo.get(User, id) do
      nil  -> {:error, "User id #{id} not found"}
      user -> {:ok, user}
    end
  end

  def find(%{}, %{source: %Subscription{} = subscription}),
    do: {:ok, subscription.user}

  def find(%{}, %{context: %{conn: conn}}),
    do: {:ok, Guardian.Plug.current_resource(conn)}

  @doc """
  Avatar from gravatar.
  """
  def image(%{size: size}, %{source: user}),
    do: {:ok, User.gravatar_url(user, size)}
end
