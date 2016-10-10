defmodule PodcatApi.ItemController do
  use PodcatApi.Web, :controller

  alias PodcatApi.Feed
  alias PodcatApi.ItemView

  @doc """
  Get a item from a feed.

  GET /feeds/{feed_id}/items/{item_id}

  ## Responses

  200 OK
  """
  def show(conn, %{"feed_id" => feed_id, "id" => item_id}) do
    item =
      Repo.get_by(Feed.Item, uuid: item_id, feed_id: feed_id)
      |> Repo.preload(:feed)

    render(conn, ItemView, "show.json", item: item)
  end
end
