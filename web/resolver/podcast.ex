defmodule PodcatApi.Resolver.Podcast do
  alias PodcatApi.{Repo, Feed, Subscription}

  @doc """
  Find podcast from id.
  """
  def find(%{id: id}, _) do
    case Repo.get(Feed.summary, id) do
      nil  -> {:error, "Podcast id #{id} not found"}
      feed -> {:ok, feed}
    end
  end

  @doc """
  Find podcast from `%Feed.Item{}`. The podcast should always be
  found and raise exception otherwise (should never happen).
  """
  def find(%{}, %{source: %Feed.Item{} = feed_item}) do
    case Repo.preload(feed_item, feed: Feed.summary) do
      %Feed.Item{feed: nil}  -> raise "Podcast id #{feed_item.feed_id} not found"
      %Feed.Item{feed: feed} -> {:ok, feed}
    end
  end

  def find(%{}, %{source: %Subscription{} = subscription}),
    do: {:ok, subscription.feed}
end
