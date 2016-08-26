defmodule PodcatApi.SearchController do
  use PodcatApi.Web, :controller

  alias PodcatApi.{Search, Feed, Subscription}

  @doc """
  Search podcasts using Itunes and join with the saved feeds.

  GET /search

  ## Params

  - `q`, the search query.

  ## Responses

  200 OK
  """
  def search(conn, %{"q" => query}) do
    user = Guardian.Plug.current_resource(conn)

    feeds =
      query
      |> Search.itunes
      |> Stream.map(&insert_result(user, &1))
      |> Enum.to_list

    render(conn, "search.json", feeds: feeds)
  end

  defp insert_result(user, item) do
    feed =
      Feed.changeset(
        %Feed{},
        %{
          "summary" => item.title,
          "author" => item.author,
          "feed_url" => item.feed_url,
          "image_url" => item.image_url
        }
      )

    Repo.insert(feed)

    if user do
      Repo.get_by!(Feed.summary(user), feed_url: item.feed_url)
      |> Repo.preload(subscribers: {Subscription.latest(5), [:user]})
    else
      Repo.get_by!(Feed.summary, feed_url: item.feed_url)
      |> Repo.preload(subscribers: {Subscription.latest(5), [:user]})
    end
  end
end
