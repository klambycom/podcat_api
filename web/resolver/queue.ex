defmodule PodcatApi.Resolver.Queue do
  alias PodcatApi.{Repo, PlaylistItem}

  @doc """
  Find user from id, current user or subscription.
  """
  def all(args, %{context: %{user: user}}) do
    filter = Map.get(args, :filter, :user_added) == :user_added
    limit = Map.get(args, :limit, 20)
    offset = Map.get(args, :offset, 0)

    user =
      Repo.preload(user, playlist_items: PlaylistItem.filter(limit, offset, filter))

    {:ok, user.playlist_items}
  end
end
