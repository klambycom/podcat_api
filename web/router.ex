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

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
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
    pipe_through [:api, :api_auth]

    post "/login", Api.SessionController, :create, as: :login
    delete "/logout", Api.SessionController, :delete, as: :logout

    resources "/feeds", FeedController do
      post "/subscribe", SubscriptionController, :create
      delete "/unsubscribe", SubscriptionController, :delete
    end

    resources "/users", Api.UserController, except: [:new, :edit] do
      resources "/subscriptions", SubscriptionController, only: [:index]
    end
  end
end
