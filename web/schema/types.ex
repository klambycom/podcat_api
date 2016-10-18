defmodule PodcatApi.Schema.Types do
  use Absinthe.Schema.Notation
  alias PodcatApi.Resolver

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
  end

  scalar :time, description: "ISO:Extended time" do
    parse &Timex.parse(&1, "{ISO:Extended}")
    serialize &Timex.format!(&1, "{ISO:Extended}")
  end
end
