defmodule PodcatApi.FeedTest do
  use PodcatApi.ModelCase

  alias PodcatApi.Feed
  alias PodcatApi.Xml.ItunesParser
  alias PodcatApi.DateUtils.RFC2822

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
    do: %ItunesParser.Podcast{
          meta: %ItunesParser.Meta{
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
          items: [
            %ItunesParser.Item{
              guid: "85fe04ad626e616030eba0c131b95bdb",
              title: "Klamby 167 - You're part of the sample",
              subtitle: "Subtitle",
              summary: "Summary",
              author: "Me",
              duration: "32:37",
              published_at: RFC2822.parse("Tue, 02 Aug 2016 03:39:05 +0000"),
              image_url: nil,
              explicit: nil,
              block: false,
              enclosure: %ItunesParser.Enclosure{
                url: "http://klamby.com/167.mp3",
                size: "16341802",
                type: "audio/mpeg"
              }
            },
            %ItunesParser.Item{
              guid: "http://klamby.com/166",
              title: "Klamby 166 - On the periphery of the monolith",
              subtitle: "Subtitle",
              summary: "Description",
              author: "Me",
              duration: "32:32",
              published_at: RFC2822.parse("Sat, 23 Jul 2016 12:23:20 +0000"),
              image_url: nil,
              explicit: nil,
              block: false,
              enclosure: %ItunesParser.Enclosure{
                url: "http://klamby.com/166.mp3",
                size: "16341802",
                type: "audio/mpeg"
              }
            }
          ],
          feed_url: "http://foobar.com/itunes_feed.xml"
        }
end
