defmodule PodcatApi.Resolver.Episode do
  alias PodcatApi.{Repo, Feed}

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
end
