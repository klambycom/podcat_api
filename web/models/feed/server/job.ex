defmodule PodcatApi.Feed.Server.Job do
  @moduledoc """
  Queue job.
  """

  defstruct feed_id: nil, priority: :low, started_at: nil, stopped_at: nil

  alias PodcatApi.Feed

  @doc """
  Create a new job from a `%PodcatApi.Feed{}`.

  ## Example

      iex> %PodcatApi.Feed{id: 123}
      ...> |> PodcatApi.Feed.Server.Job.new
      %PodcatApi.Feed.Server.Job{feed_id: 123, priority: :low}

  Set high priority:

      iex> %PodcatApi.Feed{id: 123}
      ...> |> PodcatApi.Feed.Server.Job.new(:high)
      %PodcatApi.Feed.Server.Job{feed_id: 123, priority: :high}
  """
  def new(feed, atom \\ :low)
  def new(%Feed{id: id}, :low), do: %__MODULE__{feed_id: id}
  def new(%Feed{id: id}, :high), do: %__MODULE__{feed_id: id, priority: :high}
end
