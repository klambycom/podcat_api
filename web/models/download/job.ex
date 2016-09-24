defmodule PodcatApi.Download.Job do
  @moduledoc """
  Queue job.
  """

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

defimpl String.Chars, for: PodcatApi.Download.Job do
  alias PodcatApi.Download.Job

  def to_string(%Job{feed_id: id, stopped_at: nil}), do: "Job: #{id}"

  def to_string(job) do
    running_time = DateTime.to_unix(job.stopped_at) - DateTime.to_unix(job.started_at)

    if running_time < 1 do
      "Job: #{job.feed_id} (<1s)"
    else
      "Job: #{job.feed_id} (#{running_time}s)"
    end
  end
end
