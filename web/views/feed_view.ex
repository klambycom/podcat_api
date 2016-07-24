defmodule Reader.FeedView do
  use Reader.Web, :view

  def render("index.json", %{feeds: feeds, conn: conn}),
    do: %{
      data: render_many(feeds, Reader.FeedView, "feed.json", conn: conn),
      links: %{
        self: feed_url(conn, :index)
      },
      meta: %{
        count: length(feeds)
      }
    }

  def render("show.json", %{feed: feed, conn: conn}),
    do: %{
      data: render_one(feed, Reader.FeedView, "feed.json", conn: conn),
      links: %{
        self: feed_url(conn, :show, feed)
      }
    }

  def render("feed.json", %{feed: feed, conn: conn}),
    do: %{
          title: feed.name,
          homepage: feed.homepage,
          description: feed.description,
          rss: feed.rss_feed,
          inserted_at: feed.inserted_at,
          updated_at: feed.updated_at,
          links: %{
            self: feed_url(conn, :show, feed),
            delete: feed_url(conn, :delete, feed),
            related: "TODO: posts"
          }
        }
end
