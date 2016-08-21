defmodule Reader.Router do
  use Reader.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", Reader do
    pipe_through [:api, :api_auth]

    post "/login", SessionController, :create, as: :login
    delete "/logout", SessionController, :delete, as: :logout

    resources "/feeds", FeedController do
      post "/subscribe", SubscriptionController, :create
      delete "/unsubscribe", SubscriptionController, :delete
      get "/image", ImageController, :show
    end

    resources "/users", UserController, except: [:new, :edit] do
      resources "/subscriptions", SubscriptionController, only: [:index]
    end

    get "/search", SearchController, :search
  end
end
