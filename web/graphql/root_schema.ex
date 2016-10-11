defmodule PodcatApi.GraphQL.RootSchema do
  use PodcatApi.Web, :graphql

  alias PodcatApi.Feed
  alias PodcatApi.GraphQL.{RootSchema, Podcast}

  defmodule Query do
    def type do
      %ObjectType{
        name: "Query",
        description: "All the queries available to the client",
        fields: %{
          podcast: %{
            type: Podcast,
            description: "Get a podcast",
            args: %{
              id: %{
                type: %ID{},
                description: "ID of the article"
              }
            },
            resolve: {__MODULE__, :podcast}
          }
        }
      }
    end

    def podcast(_, %{id: id}, _) do
      Repo.get!(Feed.summary, id)
    end
  end

  def schema do
    %GraphQL.Schema{query: Query.type}
  end

  def root_value(conn) do
    %{conn: conn}
  end
end
