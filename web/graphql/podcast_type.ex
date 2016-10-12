defmodule PodcatApi.GraphQL.PodcastType do
  use PodcatApi.Web, :graphql
  alias PodcatApi.GraphQL.EpisodeType
  alias PodcatApi.Feed
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
        },
        episodes: %{
          type: %List{ofType: EpisodeType},
          description: "Podcast items",
          args: %{
            limit: %{
              type: %Int{},
              description: "Number of items"
            },
            offset: %{
              type: %Int{},
              description: "Offset to start on"
            }
          },
          resolve: {__MODULE__, :items}
        }
      }
    }
  end

  def image(feed, %{size: size}, context),
    do: feed_image_url(context[:root_value][:conn], :show, feed, size: size)

  def items(feed, params, _context) do
    limit = Map.get(params, :limit, 10)
    offset = Map.get(params, :offset, 0)

    result = 
      feed
      |> Repo.preload(items: Feed.Item.latest(limit, offset))

    result.items
  end

  def dsa do
    %{
      author: nil,
      block: false,
      copyright: nil,
      description: "Latest posts in tag Elixir on Medium",
      explicit: :no,
      feed_url: "https://medium.com/feed/tag/elixir",
      id: 1,
      image_url: nil,
      inserted_at: nil,
      items: :not_loaded,
      link: "https://medium.com/tag/elixir/latest?source=rss------elixir-5",
      subscribed_at: nil,
      subscriber_count: 2,
      subscribers: :not_loaded,
      subtitle: nil,
      summary: "Elixir on Medium",
      title: nil,
      updated_at: nil,
      users: :not_loaded
    }
  end
end
