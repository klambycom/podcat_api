defmodule Reader.ImageController do
  use Reader.Web, :controller

  alias Reader.Feed

  @max_age 31 * 24 * 60 * 60 # One month

  @doc """
  Proxy for fetching images.

  GET /feeds/{feed_id}/image

  ## TODO

  - [ ] Cache original image (and maybe resized images) until the feed is
        updated. Or check if the image is updated each time. Or check if the
        image is updated each time the feed is updated.

  ## Params

  - `size`, size of the image.

  ## Responses

  - 200 OK
  - 404 Not Found
  """
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
