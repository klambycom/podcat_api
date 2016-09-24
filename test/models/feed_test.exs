defmodule PodcatApi.FeedTest do
  use PodcatApi.ModelCase

  alias PodcatApi.Feed

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
end
