defmodule PodcatApi.UserControllerTest do
  use PodcatApi.ConnCase

  alias PodcatApi.User
  @valid_attrs %{email: "foo@bar.com", name: "Foo Bar", password: "foobar123"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{email: "foo@bar.com"}
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200)["data"] == %{
      "name" => user.name,
      "id" => user.id,
      "images" => %{
        "40" => User.gravatar_url(user, 40),
        "80" => User.gravatar_url(user, 80),
        "160" => User.gravatar_url(user, 160)
      }
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, "b6c63245-e0c7-4e41-b548-939084fbb9a0")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert json_response(conn, 201)["data"]["name"]
    assert Repo.get_by(User, %{email: @valid_attrs.email})
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert json_response(conn, 200)["data"]["name"]
    assert Repo.get_by(User, %{email: @valid_attrs.email})
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end
end
