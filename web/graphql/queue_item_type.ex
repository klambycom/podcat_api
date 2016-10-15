defmodule PodcatApi.GraphQL.QueueItemType do
  use PodcatApi.Web, :graphql
  alias PodcatApi.GraphQL.{PodcastType, EpisodeType}

  def type do
    %ObjectType{
      name: "QueueItem",
      description: "Queued episode.",
      fields: %{
        id: %{
          type: %ID{},
        },
        automatically_added: %{
          type: %Boolean{},
          description: "The episode have been automatically added to the queue by a job."
        },
        datetime: DateTime.new(%{
          description: "Date and time when the episode was queued",
          type: Enum.new(%{
            name: "QueueDateTime",
            values: %{
              "QUEUED": %{value: :inserted_at}
            }
          })
        }),
        podcast: %{
          type: PodcastType,
          resolve: {__MODULE__, :podcast}
        },
        episode: %{
          type: EpisodeType,
          resolve: {__MODULE__, :episode}
        }
      }
    }
  end

  def podcast(queued_item, _, _), do: queued_item.feed_item.feed

  def episode(queued_item, _, _), do: queued_item.feed_item
end
