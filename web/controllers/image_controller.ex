defmodule Reader.ImageController do
  use Reader.Web, :controller

  alias Reader.Feed

  @max_age 31 * 24 * 60 * 60

  def show(conn, %{"feed_id" => feed_id, "size" => size}) do
    feed = Repo.get(Feed, feed_id)

    {content_type, path} = Feed.Image.download(feed)
    {:ok, image} = Feed.Image.resize(path, size)
    File.rm!(path)

    conn
    |> put_resp_header("cache-control", "public, max-age=#{@max_age}")
    |> put_resp_content_type(content_type)
    |> send_resp(:ok, image)
  end
end
