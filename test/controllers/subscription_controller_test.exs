defmodule PodcatApi.SubscriptionControllerTest do
  use PodcatApi.ConnCase

  #alias PodcatApi.Subscription
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  #test "lists all entries on index", %{conn: conn} do
  #  user = PodcatApi.Repo.get(PodcatApi.User)
  #  conn = get conn, user_subscription_path(conn, :index, user)
  #  assert json_response(conn, 200)["data"] == []
  #end

  ## TODO Test with all signed in user!
  #test "creates and renders resource when data is valid", %{conn: conn} do
  #  conn = post conn, feed_subscription_path(conn, :create), subscription: @valid_attrs
  #  assert json_response(conn, 201)["data"]["id"]
  #  assert Repo.get_by(Subscription, @valid_attrs)
  #end

  #test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #  conn = post conn, feed_subscription_path(conn, :create), subscription: @invalid_attrs
  #  assert json_response(conn, 422)["errors"] != %{}
  #end

  #test "deletes chosen resource", %{conn: conn} do
  #  subscription = Repo.insert! %Subscription{}
  #  conn = delete conn, feed_subscription_path(conn, :delete, subscription)
  #  assert response(conn, 204)
  #  refute Repo.get(Subscription, subscription.id)
  #end
end
