defmodule PodcatApi.SubscriptionController do
  use PodcatApi.Web, :controller

  alias PodcatApi.{User, Subscription}
  alias PodcatApi.SessionController

  plug Guardian.Plug.EnsureAuthenticated,
    [handler: SessionController] when action in [:create, :delete]

  @doc """
  Get all subscriptions belonging to the user.

  GET /users/{user_id}/subscriptions

  ## Responses

  200 OK
  """
  def index(conn, %{"user_id" => user_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    user = Repo.get(User, user_id)

    query =
      user
      |> Subscription.from_user

    subscriptions =
      if is_nil(current_user) do
        query
        |> Repo.all
      else
        query
        |> Subscription.join_user(current_user)
        |> Repo.all
      end

    render(conn, "index.json", subscriptions: subscriptions, user: user)
  end

  @doc """
  Subscribe to a new feed.

  POST /feeds/{feed_id}/subscribe

  ## Responses

  201 Created
  422 Unprocessable Entity
  401 Unauthorized
  """
  def create(conn, %{"feed_id" => feed_id}) do
    user = Guardian.Plug.current_resource(conn)

    changeset = Subscription.changeset(
      %Subscription{},
      %{user_id: user.id, feed_id: feed_id}
    )

    case Repo.insert(changeset) do
      {:ok, _subscription} ->
        conn
        |> send_resp(:created, "OK")
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PodcatApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  @doc """
  Unsubscribe to a feed.

  DELETE /feeds/{feed_id}/unsubscribe

  ## Responses

  204 No Content
  401 Unauthorized
  """
  def delete(conn, %{"feed_id" => feed_id}) do
    user = Guardian.Plug.current_resource(conn)

    subscription =
      Subscription
      |> Repo.get_by(user_id: user.id, feed_id: feed_id)

    if subscription do
      # Here we use delete! (with a bang) because we expect
      # it to always work (and if it does not, it will raise).
      Repo.delete!(subscription)

      conn
      |> send_resp(:no_content, "")
    else
      conn
      |> send_resp(:not_found, "")
    end
  end
end
