defmodule Reader.Xml.ItunesParserTest do
  use Reader.ModelCase
  doctest Reader.Xml.ItunesParser

  alias Reader.Xml
  alias Reader.Xml.ItunesParser

  test "valid? is false when the itunes namespace is missing" do
    document =
      Xml.from_string(
        """
        <?xml version="1.0" encoding="UTF-8" ?>
        <rss version="2.0">
          <channel>
            <title>Klamby Podcast</title>
            <itunes:subtitle>Klamby Podcast!</itunes:subtitle>
          </channel>
        </rss>
        """
      )

    refute ItunesParser.valid?(document)
  end

  test "parse meta data" do
    assert feed |> ItunesParser.meta == meta_data
  end

  test "parse podcast" do
    assert feed |> ItunesParser.parse == podcast
  end

  test "summary is the same as description if itunes:summary is missing" do
    assert feed_without_summary |> ItunesParser.parse == podcast
  end

  def podcast,
    do: %ItunesParser.Podcast{
          meta: meta_data,
          items: []
        }


  def meta_data,
    do: %ItunesParser.Meta{
          title: "Klamby Podcast",
          subtitle: "Klamby Podcast!",
          summary: "Klamby Awesome Podcast",
          author: "Christian Nilsson",
          link: "https://klamby.com",
          description: "Klamby Awesome Podcast",
          copyright: "christian",
          image_url: "http://klamby.com/bild.jpg",
          block: false,
          explicit: "yes"
        }

  def feed,
    do: Xml.from_string(
          """
          <?xml version="1.0" encoding="UTF-8" ?>
          <rss xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" version="2.0">
            <channel>
              <title>Klamby Podcast</title>
              <itunes:subtitle>Klamby Podcast!</itunes:subtitle>
              <itunes:summary>Klamby Awesome Podcast</itunes:summary>
              <itunes:author>Christian Nilsson</itunes:author>
              <itunes:explicit>yes</itunes:explicit>
              <description>Klamby Awesome Podcast</description>
              <link>https://klamby.com</link>
              <copyright>christian</copyright>
              <itunes:image href="http://klamby.com/bild.jpg" />
            </channel>
          </rss>
          """
        )

  def feed_without_summary,
    do: Xml.from_string(
          """
          <?xml version="1.0" encoding="UTF-8" ?>
          <rss xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" version="2.0">
            <channel>
              <title>Klamby Podcast</title>
              <itunes:subtitle>Klamby Podcast!</itunes:subtitle>
              <itunes:author>Christian Nilsson</itunes:author>
              <itunes:explicit>yes</itunes:explicit>
              <description>Klamby Awesome Podcast</description>
              <link>https://klamby.com</link>
              <copyright>christian</copyright>
              <itunes:image href="http://klamby.com/bild.jpg" />
            </channel>
          </rss>
          """
        )
end
