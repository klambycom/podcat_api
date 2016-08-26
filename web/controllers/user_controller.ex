defmodule PodcatApi.UserController do
  use PodcatApi.Web, :controller

  alias PodcatApi.User

  @doc """
  List all users

  ## TODO

  - Remove

  ## Responses

  - 200 OK
  """
  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  @doc """
  Create a new user.

  POST /users

  ## Data

  Content-Type: application/json

  - `user.name`
  - `user.email`
  - `user.password`

  ## Responses

  - 201 Created
  - 422 Unprocessable Entity
  """
  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PodcatApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  @doc """
  Get a user.

  GET /users/{id}

  ## Responses

  - 200 OK
  - 404 Not Found
  """
  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  @doc """
  Update user

  PUT /users/{id}

  ## Data

  Content-Type: application/json

  - `user.name`
  - `user.email`
  - `user.password`

  ## Responses

  - 200 OK
  - 422 Unprocessable Entity
  """
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PodcatApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  @doc """
  Delete user.

  DELETE /users/{id}

  ## Responses

  - 204 No Content
  - 404 Not Found
  """
  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
