defmodule PodcatApi.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema

  alias PodcatApi.Resolver
  alias PodcatApi.{Feed, User}

  import_types PodcatApi.Schema.Types

  node interface do
    resolve_type fn
      %Feed{}, _ -> :podcast
      %User{}, _ -> :user
    end
  end

  query do
    node field do
      %{type: :podcast, id: id}, _ ->
        Resolver.Podcast.find(%{id: id}, %{})
      %{type: :user, id: id}, _ ->
        Resolver.User.find(%{id: id}, %{})
      _, _ ->
        nil
    end

    @desc """
    A podcast.
    """
    field :podcast, type: :podcast do
      arg :id, non_null(:id)
      resolve &Resolver.Podcast.find/2
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
