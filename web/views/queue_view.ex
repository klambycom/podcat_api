defmodule PodcatApi.QueueView do
  use PodcatApi.Web, :view

  alias PodcatApi.ItemView

  def render("index.json", %{user: user, conn: conn}),
    do: %{
      data: render_many(
        user.playlist_items,
        __MODULE__,
        "queue_item.json",
        conn: conn
      ),
      links: [
        %{
          rel: "self",
          href: user_queue_url(conn, :index, user),
          method: "GET"
        },
        %{
          rel: "user",
          href: user_url(conn, :show, user),
          method: "GET"
        }
      ],
      meta: %{
        count: length(user.playlist_items)
      }
    }

  def render("queue_item.json", %{queue: queue_item, conn: conn}),
    do: %{
      id: queue_item.id,
      automatically_added: queue_item.automatically_added,
      item: render_one(queue_item.feed_item, ItemView, "item.json", conn: conn),
      meta: %{
        queued_at: queue_item.inserted_at
      }
    }
end
