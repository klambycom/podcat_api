defmodule PodcatApi.Download.Worker do
  use GenServer

  require Logger

  alias PodcatApi.Download.Task

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], [])
  end

  def init(state) do
    {:ok, state}
  end

  def process(pid, feed_id), do: GenServer.call(pid, {:process, feed_id})

  #
  # GenServer implementation
  #

  def handle_call({:process, feed_id}, _, state) do
    result = Task.run_all(feed_id)

    case result do
      {:ok, job} -> Logger.info(job)
      {_,   job} -> Logger.error(job)
    end

    {:reply, [result], state}
  end
end
