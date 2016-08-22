defmodule Reader.UserView do
  use Reader.Web, :view

  def render("index.json", %{users: users, conn: conn}),
    do: %{
      data: render_many(users, __MODULE__, "user.json", conn: conn),
      links: %{
        self: user_url(conn, :index)
      },
      meta: %{
        count: length(users)
      }
    }

  def render("show.json", %{user: user, conn: conn}),
    do: %{data: render_one(user, __MODULE__, "user.json", conn: nil)}
        |> add_links(user, conn)

  def render("user.json", %{user: user, conn: conn}) do
    data = %{
      name: user.name
    }

    if conn do
      data |> add_links(user, conn)
    else
      data
    end
  end

  defp add_links(data, user, conn) do
    if is_current_user(conn, user) do
      Map.put(data, :links, %{
        self: user_url(conn, :show, user),
        subscriptions: "TODO",
        playlist: "TODO"
      })
    else
      Map.put(data, :links, %{
        self: user_url(conn, :show, user)
      })
    end
  end

  defp is_current_user(conn, user) do
    current_user = Guardian.Plug.current_resource(conn)
    current_user && current_user.id == user.id
  end
end
