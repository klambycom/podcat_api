defmodule PodcatApi.UserView do
  use PodcatApi.Web, :view

  def render("index.json", %{users: users, conn: conn}),
    do: %{
      data: render_many(users, __MODULE__, "show.json", conn: conn),
      links: [
        %{
          rel: "self",
          href: user_url(conn, :index),
          method: "GET"
        }
      ],
      meta: %{
        count: length(users)
      }
    }

  def render("show.json", %{user: user, conn: conn}),
    do: %{data: render_one(user, __MODULE__, "user.json", conn: conn)}
        |> links(user, conn)

  def render("user.json", %{user: user, conn: conn}),
    do: %{
          id: user.id,
          name: user.name
        }

  defp links(data, user, conn) do
    links =
      if is_current_user(conn, user) do
        [
          %{
            rel: "self",
            href: user_url(conn, :show, user),
            method: "GET"
          },
          %{
            rel: "self",
            href: "TODO",
            method: "GET"
          },
          %{
            rel: "self",
            href: "TODO",
            method: "GET"
          }
        ]
      else
        [
          %{
            rel: "self",
            href: user_url(conn, :show, user),
            method: "GET"
          }
        ]
      end

    Map.put(data, :links, links)
  end

  defp is_current_user(conn, user) do
    current_user = Guardian.Plug.current_resource(conn)
    current_user && current_user.id == user.id
  end
end
