defmodule Reader.SubscriptionView do
  use Reader.Web, :view

  def render("index.json", %{subscriptions: subscriptions, user: user, conn: conn}),
    do: %{
      data: render_many(
        subscriptions,
        Reader.SubscriptionView,
        "subscription.json",
        conn: conn
      ),
      links: %{
        self: user_subscription_url(conn, :index, user)
      },
      meta: %{
        count: length(subscriptions)
      }
    }

  def render("subscription.json", %{subscription: subscription, conn: conn}),
    do: %{
      summary: subscription.feed.summary,
      description: subscription.feed.description,
      link: subscription.feed.link,
      feed_url: subscription.feed.feed_url,
      meta: %{
        subscribed_at: subscription.inserted_at,
        inserted_at: subscription.feed.inserted_at,
        updated_at: subscription.feed.updated_at,
        is_subscribed: subscription.is_subscribed
      },
      links: %{
        feed: feed_url(conn, :show, subscription.feed),
        subscribe: feed_subscription_url(conn, :create, subscription.feed),
        unsubscribe: feed_subscription_url(conn, :delete, subscription.feed)
      }
    }
end