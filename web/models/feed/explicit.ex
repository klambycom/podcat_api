defmodule PodcatApi.Feed.Explicit do
  @moduledoc """
  Ecto type for explicit atom.
  """

  @behaviour Ecto.Type

  def type, do: :integer

  def cast("clean"), do: {:ok, :clean}
  def cast("yes"), do: {:ok, :yes}
  def cast(_), do: {:ok, :no}

  def load(0), do: {:ok, :no}
  def load(1), do: {:ok, :yes}
  def load(2), do: {:ok, :clean}

  def dump(:no), do: {:ok, 0}
  def dump(:yes), do: {:ok, 1}
  def dump(:clean), do: {:ok, 2}
end
