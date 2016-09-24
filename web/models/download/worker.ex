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

  def process(pid, job), do: GenServer.call(pid, {:process, job})

  #
  # GenServer implementation
  #

  def handle_call({:process, job}, _, state) do
    result = Task.run_all(job)

    case result do
      {:ok, job} -> Logger.info(job)
      {_,   job} -> Logger.error(job)
    end

    {:reply, [result], state}
  end
end
