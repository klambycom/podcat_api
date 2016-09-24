defmodule PodcatApi.Download.Task.UpdateTest do
  use PodcatApi.ModelCase, async: false

  alias PodcatApi.{Repo, Feed}
  alias PodcatApi.Download.Job
  alias PodcatApi.Download.Task.Update

  doctest Update

  @feed %Feed{feed_url: "http://foobar.com/itunes_feed.xml", summary: "foobar"}

  test "download and parse RSS 2.0 file" do
    feed = Repo.insert!(@feed)

    {:ok, _} =
      feed
      |> Job.new
      |> Update.run

    result = Repo.get!(Feed, feed.id) |> Repo.preload(:items)

    assert result.author == "Christian Nilsson"
    assert result.feed_url == "http://foobar.com/itunes_feed.xml"
    assert result.image_url == "http://klamby.com/bild.jpg"
    assert length(result.items) == 2
  end
end
