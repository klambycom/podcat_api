defmodule PodcatApi.GraphQL.Podcast do
  use PodcatApi.Web, :graphql
  import PodcatApi.Router.Helpers

  def type do
    %ObjectType{
      name: "Podcast",
      description: "A podcast feed",
      fields: %{
        id: %{
          type: %Int{},
          description: "Id of the podcast"
        },
        title: %{
          type: %String{},
          description: "Title of the podcast"
        },
        subtitle: %{
          type: %String{},
          description: "Subtitle of the podcast"
        },
        summary: %{
          type: %String{},
          description: "Short description of the podcast"
        },
        description: %{
          type: %String{},
          description: "Long description of the podcast"
        },
        author: %{
          type: %String{},
          description: "Author of the podcast"
        },
        copyright: %{
          type: %String{},
          description: "Copyright of the podcast"
        },
        block: %{
          type: %Boolean{},
          description: "The podcast should be hidden if block is true"
        },
        explicit: %{
          type: %String{},
          description: "The podcast can be explicit, clean or no (rating)"
        },
        feed_url: %{
          type: %String{},
          description: "Link to the feed of the podcast"
        },
        subscriber_count: %{
          type: %Int{},
          description: "Number of subscribers"
        },
        image: %{
          type: %String{},
          description: "Url to the podcast cover",
          args: %{
            size: %{
              type: %NonNull{ofType: %Int{}},
              description: "Size of the image"
            }
          },
          resolve: {__MODULE__, :image}
        }
      }
    }
  end

  def image(feed, %{size: size}, context),
    do: feed_image_url(context[:root_value][:conn], :show, feed, size: size)
end
