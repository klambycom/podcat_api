defmodule PodcatApi.GraphQL.UserType do
  use PodcatApi.Web, :graphql

  alias PodcatApi.{User, Subscription}
  alias PodcatApi.GraphQL.SubscriptionType

  def type do
    %ObjectType{
      name: "User",
      description: "A user",
      fields: %{
        id: %{
          type: %ID{}
        },
        name: %{
          type: %String{},
          description: "Username"
        },
        image: %{
          type: %String{},
          description: "User image (from Gravatar)",
          args: %{
            size: %{
              type: %Int{}
            }
          },
          resolve: {__MODULE__, :image}
        },
        subscriptions: %{
          type: %List{ofType: SubscriptionType},
          resolve: {__MODULE__, :subscriptions}
        }
      }
    }
  end


  def image(user, %{size: size}, _),
    do: User.gravatar_url(user, size)

  def subscriptions(user, _, _),
    do: user |> Subscription.from_user |> Repo.all

  def fdsalk do
    [
      %{#%PodcatApi.Subscription{
        __meta__: nil,
        feed: %{#%PodcatApi.Feed{
          __meta__: nil,
          author: "Sveriges Radio",
          block: false,
          copyright: "Copyright Sveriges Radio 2016. All rights reserved.",
          description: "Morgonpasset i P3 hör du varje morgon, en härlig start på dagen. Här får du senaste nytt varvat med filosofiska utsvävningar, humor, kultur och intressanta gäster.\r\nAnsvarig utgivare: SÎLAN DILJEN",
          explicit: :no,
          feed_url: "http://api.sr.se/api/rss/pod/4893",
          id: 11,
          image_url: "http://sverigesradio.se/sida/images/2024/7e3d6b31-d626-4f6c-baa2-c44b890dd866.jpg?preset=api-itunes-presentation-image",
          inserted_at: nil,
          items: nil,
          link: "http://sverigesradio.se/sida/default.aspx?programid=2024",
          subscribed_at: nil,
          subscriber_count: nil,
          subscribers: nil,
          subtitle: nil,
          summary: "Morgonpasset i P3 hör du varje morgon, en härlig start på dagen. Här får du senaste nytt varvat med filosofiska utsvävningar, humor, kultur och intressanta gäster. Ansvarig utgivare: SÎLAN DILJEN",
          title: "Morgonpasset i P3",
          updated_at: nil,
          users: nil
        },
        feed_id: 11,
        id: "ea1cda1b-55e9-4f1b-9775-d0918463d259",
        inserted_at: nil,
        is_subscribed: false,
        updated_at: nil,
        user: nil,#%PodcatApi.User{},
        user_id: "47f20f1b-66dc-4cf2-acc3-5f1dfe6daa42"
      }
    ]
  end
end
