defmodule PodcatApi.GraphQL.EnclosureType do
  use PodcatApi.Web, :graphql

  def type do
    %ObjectType{
      name: "Enclosure",
      description: "A file",
      fields: %{
        url: %{
          type: %String{}
        },
        type: %{
          type: %String{}
        },
        length: %{
          type: %Int{}
        }
      }
    }
  end
end
