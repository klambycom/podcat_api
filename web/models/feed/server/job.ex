defmodule PodcatApi.Feed.Server.Job do
  @moduledoc """
  Queue job.
  """

  defstruct feed_id: nil, priority: :low, started_at: nil, stopped_at: nil

  alias PodcatApi.Feed

  @doc """
  Create a new job.

  ## Example

      iex> PodcatApi.Feed.Server.Job.new(123)
      %PodcatApi.Feed.Server.Job{feed_id: 123, priority: :low}

  Set high priority:

      iex> PodcatApi.Feed.Server.Job.new(123, :high)
      %PodcatApi.Feed.Server.Job{feed_id: 123, priority: :high}
  """
  def new(feed_id, atom \\ :low)
  def new(feed_id, :low), do: %__MODULE__{feed_id: feed_id}
  def new(feed_id, :high), do: %__MODULE__{feed_id: feed_id, priority: :high}
end
