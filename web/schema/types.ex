defmodule PodcatApi.Schema.Types do
  use Absinthe.Schema.Notation
  alias PodcatApi.{Resolver, Feed}

  @desc "A podcast"
  object :podcast do
    field :id, :id
    field :title, :string
    field :subtitle, :string
    field :summary, :string
    field :description, :string
    field :author, :string
    field :copyright, :string
    field :block, :boolean
    field :explicit, :string
    field :feed_url, :string
    field :subscriber_count, :integer
    field :episodes, list_of(:episode) do
      arg :limit, :integer
      arg :offset, :integer
      resolve &Resolver.Episode.all/2
    end
    field :updated_at, :time
    field :inserted_at, :time
    field :link, :string
    field :image, :string do
      arg :size, non_null(:integer)
      resolve &Resolver.Episode.image/2
    end
  end

  @desc "A episode"
  object :episode do
    field :uuid, :id
    field :author, :string
    field :title, :string
    field :subtitle, :string
    field :summary, :string
    field :block, :boolean
    field :explicit, :string
    field :podcast, type: :podcast do
      resolve &Resolver.Podcast.find/2
    end
    field :duration, :string do
      resolve fn _, %{source: episode} -> {:ok, Feed.Item.duration(episode)} end
    end
    field :enclosure, type: :enclosure
  end

  @desc "A episode file"
  object :enclosure do
    field :url, :string
    field :type, :string
    field :length, :integer
  end

  @desc "A user"
  object :user do
    field :id, :id
    field :name, :string
    field :image, :string do
      arg :size, non_null(:integer)
      resolve &Resolver.User.image/2
    end
    field :subscriptions, type: list_of(:user_subscription) do
      resolve &Resolver.Subscription.all/2
    end
  end

  @desc "A subscription"
  object :user_subscription do
    field :id, :id
    field :subscribed_at, :time do
      resolve fn _, %{source: user} -> {:ok, user.inserted_at} end
    end
    field :podcast, type: :podcast do
      resolve &Resolver.Podcast.find/2
    end
    field :user, type: :user do
      resolve &Resolver.User.find/2
    end
  end

  @desc "A queued episode"
  object :queued_episode do
    field :id, :id
    @desc "Have the episode been added automatically to the queue by a job."
    field :automatically_added, :boolean
    field :added_at, :time do
      resolve fn _, %{source: item} -> {:ok, item.inserted_at} end
    end
    field :podcast, type: :podcast do
      resolve fn _, %{source: item} -> {:ok, item.feed_item.feed} end
    end
    field :episode, type: :episode do
      resolve fn _, %{source: item} -> {:ok, item.feed_item} end
    end
  end

  scalar :time, description: "ISO:Extended time" do
    parse &Timex.parse(&1, "{ISO:Extended}")
    serialize &Timex.format!(&1, "{ISO:Extended}")
  end

  enum :queue_filter do
    value :user_added
    value :auto_added
  end
end
