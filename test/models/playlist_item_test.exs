defmodule PodcatApi.PlaylistItemTest do
  use PodcatApi.ModelCase

  alias PodcatApi.PlaylistItem

  @valid_attrs %{automatically_added: true, user_id: "dfds", feed_item_id: "7240e87c-92e3-4147-8a8f-0880b77c0739"}
  @valid_attrs2 %{user_id: "dfds", feed_item_id: "7240e87c-92e3-4147-8a8f-0880b77c0739"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PlaylistItem.changeset(%PlaylistItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with missing automatically_added" do
    changeset = PlaylistItem.changeset(%PlaylistItem{}, @valid_attrs2)
    assert changeset.valid?
    refute changeset.data.automatically_added
  end

  test "changeset with invalid attributes" do
    changeset = PlaylistItem.changeset(%PlaylistItem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
