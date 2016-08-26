defmodule PodcatApi.SearchView do
  use PodcatApi.Web, :view

  alias PodcatApi.FeedView

  def render("search.json", %{feeds: feeds, conn: conn}),
    do: %{
      data: render_many(feeds, FeedView, "feed.json", conn: conn),
      links: %{
        self: search_url(conn, :search)
      },
      meta: %{
        count: length(feeds)
      }
    }
end
