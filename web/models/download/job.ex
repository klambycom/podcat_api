defmodule PodcatApi.Download.Job do
  @moduledoc """
  Queue job.
  """

  defstruct feed_id: nil, data: nil, priority: :low, started_at: nil, stopped_at: nil

  @doc """
  Create a new job.

  ## Example

      iex> Job.new(123)
      %Job{feed_id: 123, priority: :low}

  Set high priority:

      iex> Job.new(123, :high)
      %Job{feed_id: 123, priority: :high}
  """
  def new(feed_id, atom \\ :low)
  def new(feed_id, :low), do: %__MODULE__{feed_id: feed_id}
  def new(feed_id, :high), do: %__MODULE__{feed_id: feed_id, priority: :high}
end
