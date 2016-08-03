defmodule Reader.SearchController do
  use Reader.Web, :controller

  alias Reader.Search

  def search(conn, %{"q" => query}) do
    result = Search.itunes(query)
    render(conn, "search.json", result: result)
  end
end
