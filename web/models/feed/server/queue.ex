defmodule PodcatApi.Feed.Server.Queue do
  @moduledoc """
  Job queue for running tasks on feeds.
  """

  defstruct low_priority: [], high_priority: []

  use GenServer

  alias PodcatApi.Download.Job

  @doc """
  Start a new queue server.
  """
  def start(name \\ :download_queue),
    do: GenServer.start(__MODULE__, nil, name: name)

  @doc """
  Add a new job to the queue.

  ## Example

      iex> Queue.start(:download_queue1)
      ...> Queue.add(:download_queue1, %Job{feed_id: 123})
      ...> Queue.add(:download_queue1, %Job{feed_id: 321})
      ...> Queue.to_list(:download_queue1)
      [
        %Job{feed_id: 123, priority: :low},
        %Job{feed_id: 321, priority: :low}
      ]

  High priority jobs will be added to a seperate queue.

      iex> Queue.start(:download_queue2)
      ...> Queue.add(:download_queue2, %Job{feed_id: 123})
      ...> Queue.add(:download_queue2, %Job{feed_id: 321})
      ...> Queue.add(:download_queue2, %Job{feed_id: 132, priority: :high})
      ...> Queue.add(:download_queue2, %Job{feed_id: 213, priority: :high})
      ...> Queue.to_list(:download_queue2)
      [
        %Job{feed_id: 132, priority: :high},
        %Job{feed_id: 213, priority: :high},
        %Job{feed_id: 123, priority: :low},
        %Job{feed_id: 321, priority: :low}
      ]
  """
  def add(queue, job), do: GenServer.cast(queue, {:add, job})

  @doc """
  Get the next job with highest priority in the queue.

  ## Example

      iex> Queue.start(:download_queue3)
      ...> Queue.add(:download_queue3, %Job{feed_id: 123})
      ...> PodcatApi.Feed.Server.Queue.add(:download_queue3, %Job{feed_id: 321})
      ...> Queue.next(:download_queue3)
      %Job{feed_id: 123, priority: :low}

  Jobs with high priority goes first.

      iex> Queue.start(:download_queue4)
      ...> Queue.add(:download_queue4, %Job{feed_id: 123})
      ...> Queue.add(:download_queue4, %Job{feed_id: 321})
      ...> Queue.add(:download_queue4, %Job{feed_id: 132, priority: :high})
      ...> Queue.add(:download_queue4, %Job{feed_id: 213, priority: :high})
      ...> Queue.next(:download_queue4)
      %Job{feed_id: 132, priority: :high}
  """
  def next(queue), do: GenServer.call(queue, :next)

  @doc """
  Get the size of the queue.

  ## Example

      iex> Queue.start(:download_queue5)
      ...> Queue.add(:download_queue5, %Job{feed_id: 123})
      ...> Queue.add(:download_queue5, %Job{feed_id: 321})
      ...> Queue.add(:download_queue5, %Job{feed_id: 132, priority: :high})
      ...> Queue.add(:download_queue5, %Job{feed_id: 213, priority: :high})
      ...> Queue.size(:download_queue5)
      4
  """
  def size(queue), do: GenServer.call(queue, :size)

  @doc """
  Get the queue in a list.
  """
  def to_list(queue), do: GenServer.call(queue, :to_list)

  #
  # GenServer implementation
  #

  def init(_), do: {:ok, %__MODULE__{}}

  def handle_cast({:add, %Job{priority: :low} = job}, queue) do
    new_state = %{queue | low_priority: List.insert_at(queue.low_priority, -1, job)}
    {:noreply, new_state}
  end

  def handle_cast({:add, %Job{priority: :high} = job}, queue) do
    new_state = %{queue | high_priority: List.insert_at(queue.high_priority, -1, job)}
    {:noreply, new_state}
  end

  def handle_call(:to_list, _, queue),
    do: {:reply, queue.high_priority ++ queue.low_priority, queue}

  def handle_call(:next, _, %__MODULE__{high_priority: [x | xs]} = queue),
    do: {:reply, x, %{queue | high_priority: xs}}

  def handle_call(:next, _, %__MODULE__{low_priority: [x | xs]} = queue),
    do: {:reply, x, %{queue | low_priority: xs}}

  def handle_call(
    :size,
    _,
    %__MODULE__{low_priority: low_priority, high_priority: high_priority} = queue
  ),
    do: {:reply, length(low_priority) + length(high_priority), queue}
end
