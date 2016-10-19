defmodule PodcatApi.Plug.Conn do
  @moduledoc """
  Save conn to the context for Absinthe. Used to create links.
  """

  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _), do: put_private(conn, :absinthe, %{context: %{conn: conn}})
end
