defmodule PodcatApi.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use PodcatApi.Web, :controller
      use PodcatApi.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema
      use Timex.Ecto.Timestamps

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias PodcatApi.Repo
      import Ecto
      import Ecto.Query

      import PodcatApi.Router.Helpers
      import PodcatApi.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      import PodcatApi.Router.Helpers
      import PodcatApi.ErrorHelpers
      import PodcatApi.Gettext
      import PodcatApi.ViewHelpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias PodcatApi.Repo
      import Ecto
      import Ecto.Query
      import PodcatApi.Gettext
    end
  end

  def graphql do
    quote do
      alias GraphQL.Type.{ObjectType, List, NonNull, ID, String, Int, Boolean, Enum}
      alias PodcatApi.Repo
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
