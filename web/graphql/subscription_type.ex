defmodule PodcatApi.GraphQL.SubscriptionType do
  use PodcatApi.Web, :graphql
  alias PodcatApi.GraphQL.{PodcastType, UserType}

  def type do
    %ObjectType{
      name: "Subscription",
      description: "A subscription",
      fields: %{
        id: %{
          type: %ID{}
        },
        datetime: DateTime.new(%{
          description: "Date and time of subscription to podcast",
          type: Enum.new(%{
            name: "SubscriptionDateTime",
            values: %{
              "SUBSCRIBED": %{value: :inserted_at}
            }
          })
        }),
        podcast: %{
          type: PodcastType,
          resolve: {__MODULE__, :podcast}
        },
        user: %{
          type: UserType,
          resolve: {__MODULE__, :user}
        }
      }
    }
  end

  def podcast(subscription, _, _), do: subscription.feed

  def user(subscription, _, _), do: subscription.user
end
