defmodule Reader.FeedController do
  use Reader.Web, :controller

  alias Reader.{Feed, User}

  plug :scrub_params, "feed" when action in [:create]

  def index(conn, _params) do
    feeds = conn |> feed_summary |> Repo.all
    render(conn, "index.json", feeds: feeds)
  end

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

  def show(conn, %{"id" => id}) do
    feed = Repo.get!(feed_summary(conn), id)

    users =
      User.subscribed_to(feed)
      |> limit(5)
      |> Repo.all

    render(conn, "show.json", feed: feed, users: users)
  end

  @doc """
  Downlaod and update the feed in another process and return 202 Accepted
  (the request has been accepted for processing) if the feed exists in the DB.

  PUT /feeds/{feed_id}

  ## Responses

  202 Accepted
  """
  def update(conn, %{"id" => id}) do
    feed = Repo.get!(Feed, id)
    spawn fn -> update_feed(feed) end

    conn
    |> send_resp(:accepted, "")
  end

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
