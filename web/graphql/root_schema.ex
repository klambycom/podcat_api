defmodule PodcatApi.GraphQL.RootSchema do
  use PodcatApi.Web, :graphql

  alias PodcatApi.{Feed, User, PlaylistItem}
  alias PodcatApi.GraphQL.{PodcastType, EpisodeType, UserType, QueueItemType}

  defmodule Query do
    def type do
      %ObjectType{
        name: "Query",
        description: "All the queries available to the client",
        fields: %{
          podcast: %{
            type: PodcastType,
            description: "A podcast",
            args: %{
              id: %{
                type: %ID{},
                description: "ID of the podcast"
              }
            },
            resolve: {__MODULE__, :podcast}
          },
          episode: %{
            type: EpisodeType,
            description: "A episode",
            args: %{
              id: %{
                type: %ID{},
                description: "ID of the episode"
              }
            },
            resolve: {__MODULE__, :episode}
          },
          user: %{
            type: UserType,
            description: """
            Get a user from the id, or the current user when id is not used.
            """,
            args: %{
              id: %{
                type: %ID{},
                description: "ID of the user"
              }
            },
            resolve: {__MODULE__, :user}
          },
          queue: %{
            type: %List{ofType: QueueItemType},
            description: """
            The play queue for the current user (the user needs to be
            authenticated). It is not possible to get the queue of another
            user.
            """,
            args: %{
              filter: %{
                type: Enum.new(%{
                  name: "QueueFilterAlternatives",
                  values: %{
                    "USER_ADDED": %{value: :user},
                    "AUTO_ADDED": %{value: :auto}
                  }
                }),
                description: """
                Filter queue by episodes added by the user or automatically
                from downloading and updating feed.
                """
              },
              limit: %{type: %Int{}},
              offset: %{type: %Int{}}
            },
            resolve: {__MODULE__, :queue}
          }
        }
      }
    end

    def podcast(_, %{id: id}, _),
      do: Repo.get!(Feed.summary, id)

    def episode(_, %{id: id}, _),
      do: Repo.get_by!(Feed.Item, uuid: id)

    def user(_, %{id: id}, _),
      do: Repo.get!(User, id)

    def user(_, _, context),
      do: Guardian.Plug.current_resource(context[:root_value][:conn])

    def queue(_, args, context) do
      filter = Map.get(args, :filter, :user)
      limit = Map.get(args, :limit, 20)
      offset = Map.get(args, :offset, 0)

      user =
        Guardian.Plug.current_resource(context[:root_value][:conn])
        |> Repo.preload(
             playlist_items: PlaylistItem.filter(limit, offset, filter == :auto)
           )

      user.playlist_items
    end
  end

  def schema, do: %GraphQL.Schema{query: Query.type}

  def root_value(conn), do: %{conn: conn}
end
