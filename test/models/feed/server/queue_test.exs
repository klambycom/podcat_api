defmodule PodcatApi.Feed.Server.QueueTest do
  use PodcatApi.ModelCase, async: false

  alias PodcatApi.Feed.Server.{Queue, Job}
  doctest Queue
end
