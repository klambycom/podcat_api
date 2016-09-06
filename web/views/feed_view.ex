defmodule PodcatApi.FeedView do
  use PodcatApi.Web, :view

  alias PodcatApi.{ItemView, SubscriptionView}

  def render("index.json", %{feeds: feeds, conn: conn}),
    do: %{
      data: render_many(feeds, __MODULE__, "show.json", conn: conn),
      links: [
        %{
          rel: "self",
          href: feed_url(conn, :index),
          method: "GET"
        }
      ],
      meta: %{
        count: length(feeds)
      }
    }

  def render("show.json", %{feed: feed, conn: conn}),
    do: %{data: render_one(feed, __MODULE__, "feed.json", conn: conn)}
        |> links(feed, conn)
        |> meta(feed)

  def render("feed.json", %{feed: feed, conn: conn}),
    do: %{
          id: feed.id,
          title: feed.title,
          subtitle: feed.subtitle,
          summary: feed.summary,
          description: feed.description,
          author: feed.author,
          link: feed.link,
          copyright: feed.copyright,
          block: feed.block,
          explicit: feed.explicit,
          feed_url: feed.feed_url,
          subscribers: render_assoc(
            feed.subscribers, SubscriptionView, "subscriber.json", conn: conn
          ),
          items: render_assoc(feed.items, ItemView, "item.json", conn: conn),
          nr_of_subscribers: feed.subscriber_count,
          images: %{
            "50": feed_image_url(conn, :show, feed, size: 50),
            "100": feed_image_url(conn, :show, feed, size: 100),
            "600": feed_image_url(conn, :show, feed, size: 600)
          }
        }

  defp links(data, feed, conn),
    do: Map.put(data, :links, [
          %{
            rel: "self",
            href: feed_url(conn, :show, feed),
            method: "GET"
          },
          %{
            rel: "delete",
            href: feed_url(conn, :delete, feed),
            method: "DELETE"
          },
          %{
            rel: "subscribe",
            href: feed_subscription_url(conn, :create, feed),
            method: "POST"
          },
          %{
            rel: "self",
            href: feed_subscription_url(conn, :delete, feed),
            method: "DELETE"
          }
        ])

  defp meta(data, feed),
    do: Map.put(data, :meta, %{
            inserted_at: feed.inserted_at,
            updated_at: feed.updated_at,
            subscribed_at: feed.subscribed_at,
            subscribers_count: length_assoc(feed.subscribers),
            items_count: length_assoc(feed.items)
        })
end
