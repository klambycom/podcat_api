defmodule PodcatApi.SearchTest do
  use PodcatApi.ModelCase

  alias PodcatApi.Search

  test "search itunes" do
    result = Search.itunes("search query")

    assert length(result) == 3
    assert List.first(result) == %Search{
      author: "Sveriges Radio",
      feed_url: "http://api.sr.se/api/rss/pod/4893",
      genre_ids: ["1324", "26"],
      image_url: "https://is2-ssl.mzstatic.com/image/thumb/Music62/v4/11/b1/a6/11b1a651-75bd-4294-5826-cabcfa09b196/source/600x600bb.jpg",
      title: "Morgonpasset i P3"
    }
  end
end
