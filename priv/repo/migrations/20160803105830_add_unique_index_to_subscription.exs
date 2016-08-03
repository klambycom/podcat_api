defmodule Reader.Repo.Migrations.AddUniqueIndexToSubscription do
  use Ecto.Migration

  def change do
    create index(:subscriptions, [:user_id, :feed_id], unique: true, name: :user_id_feed_id)
  end
end
