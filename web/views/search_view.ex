defmodule Reader.SearchView do
  use Reader.Web, :view

  def render("search.json", %{result: result, conn: conn}),
    do: %{
      data: render_many(result, __MODULE__, "result.json", as: :result, conn: conn),
      links: %{
        self: search_url(conn, :search)
      },
      meta: %{
        count: length(result)
      }
    }

  def render("result.json", %{result: result, conn: conn}),
    do: %{
      title: result.title,
      author: result.author,
      genre_ids: result.genre_ids,
      feed_url: result.feed_url,
      image_url: result.image_url
    }
end
