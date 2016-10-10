defmodule PodcatApi.QueueController do
  use PodcatApi.Web, :controller

  alias PodcatApi.{User, PlaylistItem}

  @doc """
  Get the playlist belonging to a user.

  GET /users/{user_id}/queue

  ## Responses

  200 OK
  """
  def index(conn, %{"user_id" => user_id}) do
    user =
      Repo.get(User, user_id)
      |> Repo.preload([{:playlist_items, [{:feed_item, :feed}]}])

    render(conn, "index.json", user: user)
  end
end
