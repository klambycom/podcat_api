defmodule Reader.FeedTest do
  use Reader.ModelCase

  alias Reader.Feed

  @valid_attrs %{
    title: "some content",
    subtitle: "some content",
    summary: "some content",
    author: "some content",
    description: "some content",
    link: "some content",
    summary: "some content",
    feed_url: "some content",
    copyright: "some content",
    image_url: "some content",
    block: true#,
    #explicit, Explicit, default: :no
  }

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Feed.changeset(%Feed{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Feed.changeset(%Feed{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset fields" do
    changeset = Feed.changeset(%Feed{}, @valid_attrs)
    assert changeset.changes == @valid_attrs
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

  test "download and parse podcast xml file" do
    feed = Feed.download("http://foobar.com/itunes_feed.xml")
    assert feed == itunes_feed_data
  end

  test "changeset with valid %Podcast{}" do
    feed = Feed.download("http://foobar.com/itunes_feed.xml")
    changeset = Feed.changeset(%Feed{}, feed)
    assert changeset.valid?
  end

  def itunes_feed_data,
    do: %Reader.Xml.ItunesParser.Podcast{
          meta: %Reader.Xml.ItunesParser.Meta{
            title: "Klamby Podcast",
            subtitle: "Klamby Podcast!",
            summary: "Klamby Awesome Podcast",
            author: "Christian Nilsson",
            link: "https://klamby.com",
            description: "Klamby Awesome Podcast",
            copyright: "christian",
            image_url: "http://klamby.com/bild.jpg",
            block: false
          },
          items: [],
          feed_url: "http://foobar.com/itunes_feed.xml"
        }
end
