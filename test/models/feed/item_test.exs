defmodule Reader.Feed.ItemTest do
  use Reader.ModelCase

  alias Reader.Feed.Item

  @valid_attrs %{
    guid: "unique_id",
    author: "some content",
    block: true,
    duration: "21:43",
    explicit: 42,
    published_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010},
    subtitle: "some content",
    summary: "some content",
    title: "some content",
    enclosure: %{
      type: "mp3",
      url: "http://www.google.se/podcast_1.mp3",
      length: 123
    }
  }

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Item.changeset(%Item{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Item.changeset(%Item{}, @invalid_attrs)
    refute changeset.valid?
  end
end
