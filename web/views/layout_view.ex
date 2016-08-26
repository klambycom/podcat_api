defmodule PodcatApi.LayoutView do
  use PodcatApi.Web, :view

  @doc """
  Get the current user.
  """
  def current_user(conn), do: Guardian.Plug.current_resource(conn)
end
