defmodule Reader.FeedTest do
  use Reader.ModelCase

  alias Reader.Feed

  @valid_attrs %{description: "some content", link: "some content", summary: "some content", feed_url: "some content"}
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
      link: "http://klamby.com",
      summary: "Test Blog",
      feed_url: "http://foobar.com/rss_feed.xml"
    }
  end
end
