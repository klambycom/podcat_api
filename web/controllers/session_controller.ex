defmodule Reader.SessionController do
  use Reader.Web, :controller

  alias Reader.User

  plug :scrub_params, "user" when action in [:create]

  def new(conn, params) do
    changeset = User.login_changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case User.Auth.verify(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("Logged in."))
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    Guardian.Plug.sign_out(conn)
    |> put_flash(:info, gettext("Logged out successfully."))
    |> redirect(to: page_path(conn, :index))
  end
end
