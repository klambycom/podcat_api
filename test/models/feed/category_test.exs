defmodule PodcatApi.Feed.CategoryTest do
  use PodcatApi.ModelCase

  doctest PodcatApi.Feed.Category

  alias PodcatApi.Feed.Category

  @valid_attrs %{
    itunes_id: 42,
    parent_id: 1,
    slug: "some-content",
    summary: "some content",
    title: "some content"
  }

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Category.changeset(%Category{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Category.changeset(%Category{}, @invalid_attrs)
    refute changeset.valid?
  end
end
