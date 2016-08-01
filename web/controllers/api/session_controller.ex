defmodule Reader.Api.SessionController do
  use Reader.Web, :controller

  alias Reader.User

  plug :scrub_params, "user" when action in [:create]

  #def new(conn, params) do
  #  changeset = User.login_changeset(%User{})
  #  render(conn, "new.html", changeset: changeset)
  #end

  def create(conn, %{"user" => user_params}) do
    case User.Auth.verify(user_params) do
      {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user)
        jwt = Guardian.Plug.current_token(new_conn)
        {:ok, claims} = Guardian.Plug.claims(new_conn)
        exp = Map.get(claims, "exp")
        
        new_conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", "#{exp}")
        |> render("login.json", user: user, jwt: jwt, exp: exp)
      {:error, _changeset} ->
        conn
        |> put_status(401)
        |> render("error.json", message: "Could not login")
    end
  end

  def delete(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    claims = Guardian.Plug.claims(conn)
    Guardian.revoke!(jwt, claims)

    conn
    |> put_status(200)
  end

  @doc "Show error message if the user is not authorized."
  def unauthenticated(conn, _params) do
    conn
    |> send_resp(:unauthorized, "")
  end
end
