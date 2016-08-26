defmodule PodcatApi.Feed.DurationTest do
  use PodcatApi.ModelCase

  alias PodcatApi.Feed.Duration

  test "cast ss" do
    assert Duration.cast("1234") == {:ok, 1234}
  end

  test "cast mm:ss" do
    assert Duration.cast("12:34") == {:ok, 754}
    assert Duration.cast("2:34") == {:ok, 154}
  end

  test "cast hh:mm:ss" do
    assert Duration.cast("12:34:56") == {:ok, 45_296}
    assert Duration.cast("2:34:56") == {:ok, 9_296}
  end

  test "load ss" do
    assert Duration.load(34) == {:ok, {0, 0, 34}}
  end

  test "load mm:ss" do
    assert Duration.load(754) == {:ok, {0, 12, 34}}
    assert Duration.load(154) == {:ok, {0, 2, 34}}
  end

  test "load hh:mm:ss" do
    assert Duration.load(45_296) == {:ok, {12, 34, 56}}
    assert Duration.load(9_296) == {:ok, {2, 34, 56}}
  end

  test "dump ss" do
    assert Duration.dump({0, 0, 34}) == {:ok, 34}
  end

  test "dump mm:ss" do
    assert Duration.dump({0, 12, 34}) == {:ok, 754}
    assert Duration.dump({0, 2, 34}) == {:ok, 154}
  end

  test "dump hh:mm:ss" do
    assert Duration.dump({12, 34, 56}) == {:ok, 45_296}
    assert Duration.dump({2, 34, 56}) == {:ok, 9_296}
  end
end
