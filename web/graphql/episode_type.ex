defmodule PodcatApi.GraphQL.EpisodeType do
  import String, only: [to_atom: 1]
  use PodcatApi.Web, :graphql

  alias PodcatApi.Feed
  alias PodcatApi.GraphQL.{PodcastType, EnclosureType}

  def type do
    %ObjectType{
      name: "Episode",
      description: "A podcast item",
      fields: %{
        id: %{
          type: %ID{},
          description: "Id of the podcast",
          resolve: {__MODULE__, :id}
        },
        author: %{
          type: %String{}
        },
        title: %{
          type: %String{}
        },
        subtitle: %{
          type: %String{},
          description: "Short description"
        },
        summary: %{
          type: %String{},
          description: "Longer description"
        },
        block: %{
          type: %Boolean{},
          description: "Should hide the item if block is true"
        },
        duration: %{
          type: %String{},
          description: "Duration of the episode in h:mm:ss",
          resolve: {__MODULE__, :duration}
        },
        explicit: %{
          type: %String{},
          description: "The episode can be explicit, clean or no (rating)"
        },
        enclosure: %{
          type: EnclosureType,
          description: "The episode file",
          resolve: {__MODULE__, :enclosure}
        },
        datetime: %{
          type: %String{},
          description: "Date and time of first or latest fetch, or published in feed",
          args: %{
            field: %{
              type: Enum.new(%{
                name: "Field",
                values: %{
                  "PUBLISHED": %{value: :published_at},
                  "UPDATED": %{value: :updated_at},
                  "INSERTED": %{value: :inserted_at},
                }
              })
            },
            format: %{
              type: %String{},
              description: "Format the date and time"
            }
          },
          resolve: {__MODULE__, :datetime}
        },
        podcast: %{
          type: PodcastType,
          description: "The podcast that the episode belongs to",
          resolve: {__MODULE__, :podcast}
        }
      }
    }
  end

  def id(item, _, _), do: item.uuid

  def duration(item, _, _), do: Feed.Item.duration(item)

  def enclosure(item, _, _), do: item.enclosure

  def datetime(item, args, _) do
    field = Map.get(args, :field, :published_at)
    format = Map.get(args, :format, "{YYYY}-{0M}-{D} {h24}:{m}:{s}")

    Map.get(item, field)
    |> Timex.format!(format)
  end

  def podcast(item, _, _) do
    result = item |> Repo.preload(:feed)
    result.feed
  end
end
