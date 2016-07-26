defmodule Reader.UserTest do
  use Reader.ModelCase

  alias Reader.User

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
end
