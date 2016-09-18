defmodule PodcatApi.Download.Task.Update do
  @moduledoc """
  Update a feed and its items.
  """

  @behaviour PodcatApi.Download.Task

  alias PodcatApi.{Repo, Feed}
  alias PodcatApi.{Xml, Parser}
  alias PodcatApi.Download.Job

  @http_client Application.get_env(:podcat_api, :http_client)

  @doc """
  Download the feed and save feed information and items.

  ## Example

      iex> feed =
      ...>   Repo.insert!(
      ...>     %Feed{feed_url: "http://foobar.com/itunes_feed.xml", summary: ""}
      ...>   )
      ...>
      ...> {:ok, job} = Update.run(%Job{feed_id: feed.id, priority: :low})
      ...> length(job.data)
      2
  """
  def run(%Job{feed_id: feed_id} = job) do
    feed = Repo.get!(Feed, feed_id)
    data = download(feed.feed_url)

    save_meta(feed, data)
    new_items = save_items(feed, data)

    {:ok, %{job | data: new_items}}
  end

  defp download(url) do
    {:ok, response} = @http_client.get(url)

    xml =
      response.body
      |> Xml.from_string

    case Parser.parse(xml) do
      {:ok, feed} -> %{feed | feed_url: url}
      :error -> nil
    end
  end

  # Insert or update information about the feed
  defp save_meta(feed, data),
    do: Feed.changeset(feed, data)
        |> Repo.update!

  # Insert or update the items and return new items
  defp save_items(feed, data),
    do: data.items
        |> Stream.map(&insert_item(feed.id, &1))
        |> Enum.filter(&(&1))

  defp insert_item(feed_id, item) do
    case Repo.get_by(Feed.Item, feed_id: feed_id, guid: item.guid) do
      nil ->
        Feed.Item.changeset_with_feed(feed_id, item) |> Repo.insert!
      old_item ->
        Feed.Item.changeset(old_item, item) |> Repo.update!
        false
    end
  end
end
