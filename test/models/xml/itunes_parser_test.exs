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
    assert feed |> Xml.xpath("/rss/channel") |> ItunesParser.Meta.parse == meta_data
  end

  test "parse podcast" do
    assert feed |> ItunesParser.parse == podcast
  end

  test "summary is the same as description if itunes:summary is missing" do
    assert feed_without_summary |> ItunesParser.parse == %{podcast | items: []}
  end

  test "parse items" do
    assert feed
           |> Xml.xpath("/rss/channel/item")
           |> Enum.map(&ItunesParser.Item.parse/1) == item_list
  end

  def podcast,
    do: %ItunesParser.Podcast{
          meta: meta_data,
          items: item_list
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

  def item_list,
    do: [
      %ItunesParser.Item{
        guid: "85fe04ad626e616030eba0c131b95bdb",
        title: "Klamby 167 - You're part of the sample",
        subtitle: "Subtitle",
        summary: "Summary",
        author: "Me",
        duration: "32:37",
        published_at: Reader.DateUtils.RFC2822.parse("Tue, 02 Aug 2016 03:39:05 +0000"),
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
        published_at: Reader.DateUtils.RFC2822.parse("Sat, 23 Jul 2016 12:23:20 +0000"),
        image_url: nil,
        explicit: nil,
        block: false,
        enclosure: %ItunesParser.Enclosure{
          url: "http://klamby.com/166.mp3",
          size: "16341802",
          type: "audio/mpeg"
        }
      }
    ]

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
              <item>
                <guid>85fe04ad626e616030eba0c131b95bdb</guid>
                <title>Klamby 167 - You're part of the sample</title>
                <pubDate>Tue, 02 Aug 2016 03:39:05 +0000</pubDate>
                <itunes:author>Me</itunes:author>
                <itunes:duration>32:37</itunes:duration>
                <itunes:subtitle>Subtitle</itunes:subtitle>
                <itunes:summary>Summary</itunes:summary>
                <enclosure length="16341802" type="audio/mpeg" url="http://klamby.com/167.mp3" />
                <link>http://klamby.com/167</link>
              </item>
              <item>
                <title>Klamby 166 - On the periphery of the monolith</title>
                <pubDate>Sat, 23 Jul 2016 12:23:20 +0000</pubDate>
                <itunes:author>Me</itunes:author>
                <itunes:duration>32:32</itunes:duration>
                <itunes:subtitle>Subtitle</itunes:subtitle>
                <description>Description</description>
                <enclosure length="16341802" type="audio/mpeg" url="http://klamby.com/166.mp3" />
                <link>http://klamby.com/166</link>
              </item>
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
