defmodule Reader.FeedView do
  use Reader.Web, :view

  alias Reader.Api.UserView

  def render("index.json", %{feeds: feeds, conn: conn}),
    do: %{
      data: render_many(feeds, __MODULE__, "feed.json", conn: conn),
      links: %{
        self: feed_url(conn, :index)
      },
      meta: %{
        count: length(feeds)
      }
    }

  def render("show.json", %{feed: feed, users: users, conn: conn}),
    do: %{
      data: render_one(feed, __MODULE__, "feed.json", users: users, conn: conn),
      links: %{
        self: feed_url(conn, :show, feed)
      }
    }

  def render("feed.json", %{feed: feed, conn: conn} = data) do
    users = Map.get(data, :users, [])

    %{
      author: feed.author,
      summary: feed.summary,
      homepage: feed.homepage,
      description: feed.description,
      feed_url: feed.feed_url,
      users: render_many(users, UserView, "user.json", conn: conn),
      nr_of_subscribers: feed.subscriber_count,
      meta: %{
        inserted_at: feed.inserted_at,
        updated_at: feed.updated_at,
        subscribed_at: feed.subscribed_at,
        users_count: length(users)
      },
      links: %{
        self: feed_url(conn, :show, feed),
        delete: feed_url(conn, :delete, feed),
        subscribe: feed_subscription_url(conn, :create, feed),
        unsubscribe: feed_subscription_url(conn, :delete, feed)
      }
    }
  end
end
