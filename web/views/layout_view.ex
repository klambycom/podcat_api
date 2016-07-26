defmodule Reader.LayoutView do
  use Reader.Web, :view

  @doc """
  Get the current user.
  """
  def current_user(conn), do: Guardian.Plug.current_resource(conn)
end
