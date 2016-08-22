defmodule Reader.Feed.CategoryTest do
  use Reader.ModelCase

  doctest Reader.Feed.Category

  alias Reader.Feed.Category

  @valid_attrs %{
    itunes_id: 42,
    parent_id: "7488a646-e31f-11e4-aace-600308960662",
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
