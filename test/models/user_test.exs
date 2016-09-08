defmodule PodcatApi.UserTest do
  use PodcatApi.ModelCase

  alias PodcatApi.User
  doctest PodcatApi.User

  @valid_attrs %{name: "Foo Bar", email: "foo@bar.com", password: "some content"}
  @invalid_attrs %{}

  @valid_login_attrs %{email: "foo@bar.com", password: "password"}
  @invalid_login_attrs %{}

  setup do
    user =
      User.changeset(%User{}, @valid_attrs)
      |> Repo.insert!
    {:ok, user: user}
  end

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with invalid email" do
    invalid_attrs = %{@valid_attrs | email: "invalid email"}
    assert {:email, "has invalid format"} in errors_on(%User{}, invalid_attrs)
  end

  test "password is required" do
    invalid_attrs = %{@valid_attrs | password: nil}
    assert {:password, "can't be blank"} in errors_on(%User{}, invalid_attrs)
  end

  test "email is required" do
    invalid_attrs = %{@valid_attrs | email: nil}
    assert {:email, "can't be blank"} in errors_on(%User{}, invalid_attrs)
  end

  test "email must be unique" do
    changeset = User.changeset(%User{}, @valid_attrs)

    assert {:error, changeset} = Repo.insert(changeset)
    assert [email: {"has already been taken", []}] == changeset.errors
  end

  test "login_changeset with valid attributes" do
    changeset = User.login_changeset(%User{}, @valid_login_attrs)
    assert changeset.valid?
  end

  test "login_changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_login_attrs)
    refute changeset.valid?
  end

  test "gravatar url from user" do
    url =
      %User{email: "MyEmailAddress@example.com "}
      |> User.gravatar_url

    assert url == "https://www.gravatar.com/avatar/0bc83cb571cd1c50ba6f3e8a78ef1346?d=identicon&s=80"
  end

  test "bigger gravatar url from user" do
    url =
      %User{email: "MyEmailAddress@example.com "}
      |> User.gravatar_url(200)

    assert url == "https://www.gravatar.com/avatar/0bc83cb571cd1c50ba6f3e8a78ef1346?d=identicon&s=200"
  end
end
