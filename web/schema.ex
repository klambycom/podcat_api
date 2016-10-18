defmodule PodcatApi.Schema do
  use Absinthe.Schema
  alias PodcatApi.Resolver

  import_types PodcatApi.Schema.Types

  query do
    field :podcast, type: :podcast do
      arg :id, non_null(:id)
      resolve &Resolver.Podcast.find/2
    end
  end
end
