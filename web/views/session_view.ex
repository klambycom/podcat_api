defmodule Reader.SessionView do
  use Reader.Web, :view

  def render("login.json", %{user: user, jwt: jwt, exp: exp}),
    do: %{
      jwt: jwt,
      exp: exp
    }

  def render("error.json", %{message: message}),
    do: %{errors: [%{message: message}]}
end
