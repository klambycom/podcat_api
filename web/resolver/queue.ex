defmodule PodcatApi.Resolver.Queue do
  alias PodcatApi.{Repo, PlaylistItem}

  @doc """
  Find user from id, current user or subscription.
  """
  def all(args, %{context: %{conn: conn}}) do
    filter = Map.get(args, :filter, :user_added) == :user_added
    limit = Map.get(args, :limit, 20)
    offset = Map.get(args, :offset, 0)


    user =
      Guardian.Plug.current_resource(conn)
      |> Repo.preload(playlist_items: PlaylistItem.filter(limit, offset, filter))

    {:ok, user.playlist_items}
  end
end
