defmodule PodcatApi.Resolver.Subscription do
  alias PodcatApi.{Repo, Subscription}

  @doc """
  All subscription belonging to a user.
  """
  def all(_, %{source: user}),
    do: {:ok, user |> Subscription.from_user |> Repo.all}
end
