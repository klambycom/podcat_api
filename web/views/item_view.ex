defmodule PodcatApi.ItemView do
  use PodcatApi.Web, :view

  alias PodcatApi.Feed.Enclosure

  def render("show.json", %{item: item, conn: conn}),
    do: %{
      data: render_one(item, __MODULE__, "item.json", conn: conn),
      meta: %{
        inserted_at: item.inserted_at,
        updated_at: item.updated_at,
        published_at: item.published_at
      },
      links: [
        %{
          rel: "self",
          href: feed_item_url(conn, :show, item.feed, item),
          method: "GET"
        }
      ]
    }

  def render("item.json", %{item: item, conn: _conn}),
    do: %{
      id: item.uuid,
      title: item.title,
      subtitle: item.subtitle,
      author: item.author,
      duration: render_duration(item.duration),
      explicit: item.explicit,
      enclosure: render_enclosure(item.enclosure)
    }

  defp render_duration({hour, minute, second}),
    do: "#{hour}:#{String.rjust("#{minute}", 2, ?0)}:#{String.rjust("#{second}", 2, ?0)}"

  defp render_enclosure(%Enclosure{url: url, type: type, length: size}),
    do: %{url: url, type: type, size: size}
end
