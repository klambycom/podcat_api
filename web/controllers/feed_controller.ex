defmodule Reader.FeedController do
  use Reader.Web, :controller

  alias Reader.{Feed, User, Subscription}

  plug :scrub_params, "feed" when action in [:create]

  @doc """
  Show all feeds (but not items).

  GET /feeds

  ## TODO

  - [ ] Filter categories
  - [ ] Limit and offset

  ## Params

  - `subscribers[limit]`, default is 5.

  ## Responses

  - 200 OK
  """
  def index(conn, %{"subscribers" => subscribers}) do
    feeds =
      conn
      |> feed_summary
      |> Repo.all
      |> Repo.preload(
           subscribers: {Subscription.latest(Map.get(subscribers, "limit", 5)), [:user]}
         )

    render(conn, "index.json", feeds: feeds)
  end

  def index(conn, params), do: index(conn, Map.merge(%{"subscribers" => %{}}, params))

  @doc """
  Create a new feed from a url.

  POST /feeds

  ## TODO

  - Remove?

  ## Data

  Content-Type: application/json

  - `feed`, url to the feed.

  ## Responses

  - 201 Created
  - 422 Unprocessable Entity
  """
  def create(conn, %{"feed" => url}) do
    feed_params = Feed.download(url)
    changeset = Feed.changeset(%Feed{}, feed_params)

    case Repo.insert(changeset) do
      {:ok, feed} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", feed_path(conn, :show, feed))
        |> render("show.json", feed: feed)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Reader.ChangesetView, "error.json", changeset: changeset)
    end
  end

  @doc """
  Show a feed with its items and the 5 newest subscribers.

  GET /feeds/{feed_id}

  ## Params

  Item pagination:

  - `item[limit]`, default is 20.
  - `item[offset]`, default is 0.
  - `subscribers[limit]`, default is 5.

  ## Responses

  - 200 OK
  - 404 Not Found
  """
  def show(conn, %{"id" => id, "subscribers" => subscribers, "items" => items}) do
    feed =
      Repo.get!(feed_summary(conn), id)
      |> Repo.preload(
           items: Feed.Item.latest(Map.get(items, "limit", 20), Map.get(items, "offset", 0)),
           subscribers: {Subscription.latest(Map.get(subscribers, "limit", 5)), [:user]}
         )

    render(conn, "show.json", feed: feed)
  end

  def show(conn, params),
    do: show(conn, Map.merge(%{"subscribers" => %{}, "items" => %{}}, params))

  @doc """
  Downlaod and update the feed in another process and return 202 Accepted
  (the request has been accepted for processing) if the feed exists in the DB.

  PUT /feeds/{feed_id}

  ## Responses

  - 202 Accepted
  - 404 Not found
  """
  def update(conn, %{"id" => id}) do
    feed = Repo.get!(Feed, id)
    spawn fn -> update_feed(feed) end

    conn
    |> send_resp(:accepted, "")
  end

  @doc """
  Delete a feed.

  DELETE /feeds/{feed_id}

  ## TODO

  - [ ] Remove? It should not be posible to remove a feed, not even as a admin.
  - [ ] Automation of removing. Remove if the feed have no episodes.

  ## Responses

  - 204 No Content
  """
  def delete(conn, %{"id" => id}) do
    feed = Repo.get!(Feed, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(feed)

    conn
    |> send_resp(:no_content, "")
  end

  defp feed_summary(conn) do
    user = Guardian.Plug.current_resource(conn)

    if user do
      Feed.summary(user)
    else
      Feed.summary
    end
  end

  defp update_feed(feed) do
    data = Feed.download(feed)
    Feed.changeset(feed, data) |> Repo.update!

    data.items
    |> Stream.map(&insert_item(feed.id, &1))
    |> Enum.filter(&(&1)) # New items (TODO update playlists)
  end

  defp insert_item(feed_id, item) do
    case Repo.get_by(Feed.Item, feed_id: feed_id, guid: item.guid) do
      nil ->
        Feed.Item.changeset_with_feed(feed_id, item) |> Repo.insert!
      old_item ->
        Feed.Item.changeset(old_item, item) |> Repo.update!
        false
    end
  end
end
