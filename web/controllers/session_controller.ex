defmodule Reader.SessionController do
  use Reader.Web, :controller

  alias Reader.User

  plug :scrub_params, "user" when action in [:create]

  @doc """
  Sign in a user.

  POST /login

  ## Data

  Content-Type: application/json

  - `user.email`
  - `user.password`

  ## Responses

  - 200 OK
  - 401 Unauthorized
  """
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
        |> put_status(:unauthorized)
        |> render("error.json", message: "Could not login")
    end
  end

  @doc """
  Sign out the user.

  DELETE /logout

  ## Responses

  - 200 OK
  """
  def delete(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    claims = Guardian.Plug.claims(conn)
    Guardian.revoke!(jwt, claims)

    conn
    |> put_status(:ok)
  end

  @doc "Show error message if the user is not authorized (401 unauthorized)."
  def unauthenticated(conn, _params) do
    conn
    |> send_resp(:unauthorized, "")
  end
end
