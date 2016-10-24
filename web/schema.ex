defmodule PodcatApi.Schema do
  use Absinthe.Schema
  alias PodcatApi.Resolver

  import_types PodcatApi.Schema.Types

  query do
    @desc """
    A podcast.
    """
    field :podcast, type: :podcast do
      arg :id, non_null(:id)
      resolve &Resolver.Podcast.find/2
    end

    @desc """
    Get several podcasts using different filters.
    """
    field :podcasts, type: list_of(:podcast) do
      arg :limit, non_null(:integer)
      arg :offset, :integer
      arg :filter, non_null(:podcast_filter)
      resolve &Resolver.Podcast.all/2
    end

    @desc """
    Get the user from a id, or the current user when id is not
    used.
    """
    field :user, type: :user do
      arg :id, :id
      resolve &Resolver.User.find/2
    end

    @desc """
    The play queue for the current user (the user needs to be
    authenticated). It is not possible to get the queue of
    another user.
    """
    field :queue, type: list_of(:queued_episode) do
      arg :limit, :integer
      arg :offset, :integer
      arg :filter, :queue_filter
      resolve &Resolver.Queue.all/2
    end
  end
end