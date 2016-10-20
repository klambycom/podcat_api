defmodule PodcatApi.Plug.User do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    case Guardian.Plug.current_resource(conn) do
      nil  -> send_resp(conn, 403, "Invalid or missing authorization token")
      user -> put_private(conn, :absinthe, %{context: add_to_context(conn, user)})
    end
  end

  defp add_to_context(conn, user),
    do: Map.put(conn.private[:absinthe][:context], :user, user)
end
