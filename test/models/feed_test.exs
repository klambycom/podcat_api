defmodule Reader.FeedTest do
  use Reader.ModelCase

  alias Reader.Feed

  @valid_attrs %{description: "some content", homepage: "some content", name: "some content", rss_feed: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Feed.changeset(%Feed{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Feed.changeset(%Feed{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "download and parse RSS 2.0 file" do
    feed = Feed.download("http://foobar.com/rss_feed.xml")

    assert feed == %{
      description: "A blog.",
      homepage: "http://klamby.com",
      name: "Test Blog",
      rss_feed: "http://foobar.com/rss_feed.xml"
    }
  end
end
