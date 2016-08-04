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

  def update(conn, %{"id" => id}) do
    feed = Repo.get!(Feed, id)
    feed_params = Feed.download(feed.feed_url)
    changeset = Feed.changeset(feed, feed_params)

    case Repo.update(changeset) do
      {:ok, feed} ->
        conn
        |> render("show.json", feed: feed)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Reader.ChangesetView, "error.json", changeset: changeset)
    end
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
end
