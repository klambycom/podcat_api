defmodule PodcatApi.GraphQL.RootSchema do
  use PodcatApi.Web, :graphql

  alias PodcatApi.{Feed, User}
  alias PodcatApi.GraphQL.{RootSchema, PodcastType, EpisodeType, UserType}

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
            description: "A user",
            args: %{
              id: %{
                type: %ID{},
                description: "ID of the user"
              }
            },
            resolve: {__MODULE__, :user}
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
  end

  def schema, do: %GraphQL.Schema{query: Query.type}

  def root_value(conn), do: %{conn: conn}
end
