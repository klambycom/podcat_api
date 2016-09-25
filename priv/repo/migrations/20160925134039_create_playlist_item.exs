defmodule PodcatApi.Repo.Migrations.CreatePlaylistItem do
  use Ecto.Migration

  def change do
    create table(:playlist_items, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :automatically_added, :boolean, default: false, null: false

      add :user_id, references(:users, type: :uuid, on_delete: :delete_all)
      add :feed_item_id, references(:feed_items, column: :uuid, type: :uuid, on_delete: :delete_all)

      timestamps()
    end

    create index(:playlist_items, [:user_id])
    create index(:playlist_items, [:feed_item_id])
  end
end
