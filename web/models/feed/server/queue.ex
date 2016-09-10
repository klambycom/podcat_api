defmodule PodcatApi.Feed.Server.Queue do
  @moduledoc """
  Job queue for running tasks on feeds.
  """

  defstruct low_priority: [], high_priority: []

  alias PodcatApi.Feed.Server.Job

  @doc """
  Add a new job to the queue.

  ## Example

      iex> %PodcatApi.Feed.Server.Queue{}
      ...> |> PodcatApi.Feed.Server.Queue.add(%PodcatApi.Feed.Server.Job{feed_id: 123})
      ...> |> PodcatApi.Feed.Server.Queue.add(%PodcatApi.Feed.Server.Job{feed_id: 321})
      %PodcatApi.Feed.Server.Queue{
        low_priority: [
          %PodcatApi.Feed.Server.Job{feed_id: 123, priority: :low},
          %PodcatApi.Feed.Server.Job{feed_id: 321, priority: :low}
        ],
        high_priority: []
      }

  High priority jobs will be added to a seperate queue.

      iex> %PodcatApi.Feed.Server.Queue{}
      ...> |> PodcatApi.Feed.Server.Queue.add(%PodcatApi.Feed.Server.Job{feed_id: 123})
      ...> |> PodcatApi.Feed.Server.Queue.add(%PodcatApi.Feed.Server.Job{feed_id: 321})
      ...> |> PodcatApi.Feed.Server.Queue.add(
      ...>      %PodcatApi.Feed.Server.Job{feed_id: 132, priority: :high}
      ...>    )
      ...> |> PodcatApi.Feed.Server.Queue.add(
      ...>      %PodcatApi.Feed.Server.Job{feed_id: 213, priority: :high}
      ...>    )
      %PodcatApi.Feed.Server.Queue{
        low_priority: [
          %PodcatApi.Feed.Server.Job{feed_id: 123, priority: :low},
          %PodcatApi.Feed.Server.Job{feed_id: 321, priority: :low}
        ],
        high_priority: [
          %PodcatApi.Feed.Server.Job{feed_id: 132, priority: :high},
          %PodcatApi.Feed.Server.Job{feed_id: 213, priority: :high}
        ]
      }
  """
  def add(queue, %Job{priority: :low} = job),
    do: %{queue | low_priority: List.insert_at(queue.low_priority, -1, job)}

  def add(queue, %Job{priority: :high} = job),
    do: %{queue | high_priority: List.insert_at(queue.high_priority, -1, job)}

  @doc """
  Get the next job with highest priority in the queue.

  ## Example

      iex> %PodcatApi.Feed.Server.Queue{
      ...>   low_priority: [
      ...>     %PodcatApi.Feed.Server.Job{feed_id: 123, priority: :low},
      ...>     %PodcatApi.Feed.Server.Job{feed_id: 321, priority: :low}
      ...>   ],
      ...>   high_priority: []
      ...> }
      ...> |> PodcatApi.Feed.Server.Queue.next
      {
        %PodcatApi.Feed.Server.Job{feed_id: 123, priority: :low},
        %PodcatApi.Feed.Server.Queue{
          low_priority: [
            %PodcatApi.Feed.Server.Job{feed_id: 321, priority: :low}
          ],
          high_priority: []
        }
      }

  Jobs with high priority goes first.

      iex> %PodcatApi.Feed.Server.Queue{
      ...>   low_priority: [
      ...>     %PodcatApi.Feed.Server.Job{feed_id: 123, priority: :low},
      ...>     %PodcatApi.Feed.Server.Job{feed_id: 321, priority: :low}
      ...>   ],
      ...>   high_priority: [
      ...>     %PodcatApi.Feed.Server.Job{feed_id: 132, priority: :high},
      ...>     %PodcatApi.Feed.Server.Job{feed_id: 213, priority: :high}
      ...>   ]
      ...> }
      ...> |> PodcatApi.Feed.Server.Queue.next
      {
        %PodcatApi.Feed.Server.Job{feed_id: 132, priority: :high},
        %PodcatApi.Feed.Server.Queue{
          low_priority: [
            %PodcatApi.Feed.Server.Job{feed_id: 123, priority: :low},
            %PodcatApi.Feed.Server.Job{feed_id: 321, priority: :low}
          ],
          high_priority: [
            %PodcatApi.Feed.Server.Job{feed_id: 213, priority: :high}
          ]
        }
      }
  """
  def next(%__MODULE__{high_priority: [x | xs]} = queue),
    do: {x, %{queue | high_priority: xs}}

  def next(%__MODULE__{low_priority: [x | xs]} = queue),
    do: {x, %{queue | low_priority: xs}}

  @doc """
  Get the size of the queue.

  ## Example

      iex> %PodcatApi.Feed.Server.Queue{
      ...>   low_priority: [
      ...>     %PodcatApi.Feed.Server.Job{feed_id: 123, priority: :low},
      ...>     %PodcatApi.Feed.Server.Job{feed_id: 321, priority: :low}
      ...>   ],
      ...>   high_priority: [
      ...>     %PodcatApi.Feed.Server.Job{feed_id: 132, priority: :high},
      ...>     %PodcatApi.Feed.Server.Job{feed_id: 213, priority: :high}
      ...>   ]
      ...> }
      ...> |> PodcatApi.Feed.Server.Queue.size
      4
  """
  def size(%__MODULE__{low_priority: low_priority, high_priority: high_priority}),
    do: length(low_priority) + length(high_priority)
end
