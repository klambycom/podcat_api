defmodule PodcatApi.Download.Task do
  @moduledoc """
  Run a task on the jobs in the queue.
  """

  @callback run(map) :: tuple
end
