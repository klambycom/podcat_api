defmodule PodcatApi.Download.Job do
  @moduledoc """
  Queue job.
  """

  require Logger

  alias PodcatApi.Feed

  defstruct feed_id: nil, data: nil, priority: :low, started_at: nil, stopped_at: nil

  @doc """
  Create a new job.

  ## Example

      iex> feed = %Feed{id: 123}
      ...> Job.new(feed)
      %Job{feed_id: 123, priority: :low}

  Set high priority:

      iex> feed = %Feed{id: 123}
      ...> Job.new(feed, :high)
      %Job{feed_id: 123, priority: :high}
  """
  def new(feed, atom \\ :low)

  def new(%Feed{id: feed_id}, :low),
    do: %__MODULE__{feed_id: feed_id}

  def new(%Feed{id: feed_id}, :high),
    do: %__MODULE__{feed_id: feed_id, priority: :high}
end
