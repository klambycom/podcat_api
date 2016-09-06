defmodule PodcatApi.ItemView do
  use PodcatApi.Web, :view

  alias PodcatApi.Feed.Enclosure

  def render("item.json", %{item: item, conn: _conn}),
    do: %{
          id: item.uuid,
          title: item.title,
          subtitle: item.subtitle,
          author: item.author,
          duration: render_duration(item.duration),
          explicit: item.explicit,
          enclosure: render_enclosure(item.enclosure),
          meta: %{
            inserted_at: item.inserted_at,
            updated_at: item.updated_at,
            published_at: item.published_at
          },
        }

  defp render_duration({hour, minute, second}),
    do: "#{hour}:#{String.rjust("#{minute}", 2, ?0)}:#{String.rjust("#{second}", 2, ?0)}"

  defp render_enclosure(%Enclosure{url: url, type: type, length: size}),
    do: %{url: url, type: type, size: size}
end
