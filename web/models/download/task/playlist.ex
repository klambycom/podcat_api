defmodule PodcatApi.Download.Task.Playlist do
  @moduledoc """
  Add the new items to all playlists that subscribe to the feed.
  """

  @behaviour PodcatApi.Download.Task

  alias PodcatApi.Download.Job
  alias PodcatApi.{Repo, Subscription, PlaylistItem}
  alias PodcatApi.Feed.Item

  @doc """
  Update playlists with the new items.
  """
  def run(%Job{} = job) do
    changesets(job)
    |> Enum.map(&Repo.insert/1)

    {:ok, job}
  end

  defp changesets(%Job{feed_id: feed_id, data: new_items}),
    do: for %Subscription{user_id: user_id} <- subscriptions(feed_id),
            %Item{uuid: item_id} <- new_items,
            into: [],
            do: changeset(user_id, item_id)

  defp subscriptions(feed_id),
    do: feed_id
        |> Subscription.feed_id
        |> Repo.all

  defp changeset(user_id, item_id),
    do: PlaylistItem.changeset(
          %PlaylistItem{},
          %{automatically_added: true, user_id: user_id, feed_item_id: item_id}
        )
end
