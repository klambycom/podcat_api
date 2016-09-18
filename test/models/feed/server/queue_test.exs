defmodule PodcatApi.Feed.Server.QueueTest do
  use PodcatApi.ModelCase, async: false

  alias PodcatApi.Feed.Server.Queue
  alias PodcatApi.Download.Job

  doctest Queue
end
