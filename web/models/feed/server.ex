defmodule PodcatApi.Feed.Server do
  @moduledoc """
  Download feeds.

  TODO Restrict how many jobs that can run simultanity.
  """

  use GenServer

  alias PodcatApi.Feed
  alias PodcatApi.Feed.Server.{Queue, Job}

  @doc """
  Start a new feed server.

  TODO Maybe use :timer.send_interval/2 to check if feeds needs to be added to
       queue to get updated
  """
  def start(name \\ :feed_server),
    do: GenServer.start(__MODULE__, nil, name: name)

  @doc """
  Add a new feed for downloading.
  """
  def download(server, %Feed{id: feed_id}),
    do: GenServer.cast(server, {:download, feed_id})

  @doc """
  Get the total number of jobs in the queue.

  ## Example

      iex> PodcatApi.Feed.Server.start
      ...> PodcatApi.Feed.Server.download(:feed_server, %PodcatApi.Feed{id: 123})
      ...> PodcatApi.Feed.Server.download(:feed_server, %PodcatApi.Feed{id: 321})
      ...> PodcatApi.Feed.Server.size(:feed_server)
      %{jobs: 2}
  """
  def size(server), do: GenServer.call(server, :size)

  #
  # GenServer implementation
  #

  def init(_), do: {:ok, %Queue{}}

  def handle_cast({:download, feed_id}, queue) do
    job = Job.new(feed_id)
    new_state = Queue.add(queue, job)
    {:noreply, new_state}
  end

  def handle_call(:size, _, queue),
    do: {:reply, %{jobs: Queue.size(queue)}, queue}
end
