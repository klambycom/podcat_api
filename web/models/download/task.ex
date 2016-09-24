defmodule PodcatApi.Download.Task do
  @moduledoc """
  Run a task on the jobs in the queue.
  """

  @callback run(map) :: tuple

  @tasks [
    PodcatApi.Download.Task.Update
  ]

  def run_all(job, tasks \\ @tasks) do
    job = %{job | started_at: DateTime.utc_now}

    {status, job} =
      Enum.reduce_while(tasks, {:ok, job}, fn(task, {_, acc}) ->
        case task.run(acc) do
          {:halt,  job} -> {:halt, {:ok,    job}}
          {:error, job} -> {:halt, {:error, job}}
          {_,      job} -> {:cont, {:ok,    job}}
        end
      end)

    {status, %{job | stopped_at: DateTime.utc_now}}
  end
end
