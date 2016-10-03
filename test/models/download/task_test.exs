defmodule PodcatApi.Download.TaskTest do
  use PodcatApi.ModelCase

  alias PodcatApi.{Repo, Feed, User, Subscription, PlaylistItem}
  alias PodcatApi.Download.{Task, Job}

  @feed %Feed{
    feed_url: "http://foobar.com/itunes_feed.xml",
    summary: "Testing a feed"
  }

  @user %User{
    name: "Foo Bar",
    email: "foo@bar.com",
    password: "some content"
  }

  @user2 %User{
    name: "Foo Baz",
    email: "foo@baz.com",
    password: "some content"
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

  test "update the playlists of all subscribers" do
    feed = Repo.insert!(@feed)
    user = Repo.insert!(@user)
    user2 = Repo.insert!(@user2)

    Repo.insert!(%Subscription{user_id: user.id, feed_id: feed.id})
    Repo.insert!(%Subscription{user_id: user2.id, feed_id: feed.id})

    # The playlist is empty before the jobs have run
    items = Repo.all(from p in PlaylistItem, where: p.user_id == ^user.id)
    assert items == []

    {:ok, _job} =
      feed
      |> Job.new
      |> Task.run_all

    items = Repo.all(from p in PlaylistItem, where: p.user_id == ^user.id)
    assert length(items) == 2
    assert List.first(items).automatically_added
  end
end
