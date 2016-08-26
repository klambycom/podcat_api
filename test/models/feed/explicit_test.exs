defmodule PodcatApi.Feed.ExplicitTest do
  use PodcatApi.ModelCase

  alias PodcatApi.Feed.Explicit

  test "cast clean" do
    assert Explicit.cast("clean") == {:ok, :clean}
  end

  test "cast yes" do
    assert Explicit.cast("yes") == {:ok, :yes}
  end

  test "cast no" do
    assert Explicit.cast("no") == {:ok, :no}
    assert Explicit.cast("maybe") == {:ok, :no}
    assert Explicit.cast(nil) == {:ok, :no}
  end

  test "load" do
    assert Explicit.load(0) == {:ok, :no}
    assert Explicit.load(1) == {:ok, :yes}
    assert Explicit.load(2) == {:ok, :clean}
  end

  test "dump" do
    assert Explicit.dump(:no) == {:ok, 0}
    assert Explicit.dump(:yes) == {:ok, 1}
    assert Explicit.dump(:clean) == {:ok, 2}
  end
end
