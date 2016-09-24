defmodule PodcatApi.Download do
  use Application

  alias PodcatApi.Feed
  alias PodcatApi.Download.Worker

  @pool_name :download_pool

  def start_link do
    poolboy_config = [
      {:name, {:local, @pool_name}},
      {:worker_module, PodcatApi.Download.Worker},
      {:size, 2},
      {:max_overflow, 1}
    ]

    children = [
      :poolboy.child_spec(@pool_name, poolboy_config, [])
    ]

    options = [
      strategy: :one_for_one,
      name: PodcatApi.Download.Supervisor
    ]

    Supervisor.start_link(children, options)
  end

  @doc """
  Download feed.
  """
  def feed(%Feed{id: feed_id}) do
    :poolboy.transaction(@pool_name, &Worker.process(&1, feed_id))
  end
end
