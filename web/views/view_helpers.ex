defmodule Reader.ViewHelpers do
  @doc """
  Render a collection of associations or a empty list. Works even if the association
  is not preloaded.
  """
  def render_assoc(collection, view, template, assigns \\ %{})

  def render_assoc(%Ecto.Association.NotLoaded{}, _, _, _), do: []

  def render_assoc(collection, view, template, assigns),
    do: Phoenix.View.render_many(collection, view, template, assigns)

  @doc """
  Get length of collection of associations or 0 if the associations is not
  preloaded.
  """
  def length_assoc(%Ecto.Association.NotLoaded{}), do: 0
  def length_assoc(collection), do: length(collection)
end
