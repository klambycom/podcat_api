defmodule Reader.Router do
  use Reader.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Reader do
    pipe_through [:browser, :browser_session]

    get "/", PageController, :index

    get "/login", SessionController, :new, as: :login
    post "/login", SessionController, :create, as: :login

    delete "/logout", SessionController, :delete, as: :logout

    resources "/users", UserController
  end

  scope "/api", Reader do
    pipe_through :api

    resources "/feeds", FeedController
  end
end
