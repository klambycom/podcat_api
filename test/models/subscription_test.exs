defmodule PodcatApi.SubscriptionTest do
  use PodcatApi.ModelCase

  alias PodcatApi.Subscription

  @valid_attrs %{user_id: "47f20f1b-66dc-4cf2-acc3-5f1dfe6daa42", feed_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Subscription.changeset(%Subscription{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Subscription.changeset(%Subscription{}, @invalid_attrs)
    refute changeset.valid?
  end
end
