defmodule PodcatApi.SessionView do
  use PodcatApi.Web, :view

  def render("login.json", %{user: _user, jwt: jwt, exp: exp}),
    do: %{
      jwt: jwt,
      exp: exp
    }

  def render("error.json", %{message: message}),
    do: %{errors: [%{message: message}]}
end
