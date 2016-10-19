defmodule PodcatApi.Resolver.Episode do
  alias PodcatApi.{Repo, Feed, Router}

  @doc """
  All episodes from a podcast. Source needs to be a `%Feed{}`.
  """
  def all(args, %{source: %Feed{} = feed}) do
    limit = Map.get(args, :limit, 10)
    offset = Map.get(args, :offset, 0)

    case Repo.preload(feed, items: Feed.Item.latest(limit, offset)) do
      nil  -> {:error, "Episodes not found"}
      feed -> {:ok, feed.items}
    end
  end

  @doc """
  Get cover image for a podcast.
  """
  def image(%{size: size}, %{context: %{conn: conn}, source: feed}),
    do: {:ok, Router.Helpers.feed_image_url(conn, :show, feed, size: size)}
end
