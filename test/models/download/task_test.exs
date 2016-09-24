defmodule PodcatApi.Download.TaskTest do
  use PodcatApi.ModelCase

  alias PodcatApi.{Repo, Feed}
  alias PodcatApi.Download.{Task, Job}

  @feed %Feed{
    feed_url: "http://foobar.com/itunes_feed.xml",
    summary: "Testing a feed"
  }

  test "run all tasks on a job" do
    feed = Repo.insert!(@feed)

    {:ok, job} =
      feed
      |> Job.new
      |> Task.run_all

    refute is_nil(job.started_at)
    refute is_nil(job.stopped_at)
    assert job.feed_id == feed.id
  end
end
