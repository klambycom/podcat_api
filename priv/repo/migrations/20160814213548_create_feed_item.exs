defmodule Reader.Repo.Migrations.CreateFeed.Item do
  use Ecto.Migration

  def change do
    create table(:feed_items, primary_key: false) do
      add :feed_id, references(:feeds), null: false, primary_key: true
      add :guid, :string, null: false, primary_key: true,
        comment: "Unique id of the item (created by feed owner)"

      add :uuid, :uuid, autogenerate: true

      add :title, :string
      add :subtitle, :string
      add :summary, :text
      add :author, :string
      add :duration, :integer, comment: "Duration of the podcast-episode (enclosure) in seconds"
      add :explicit, :integer
      add :image_url, :string
      add :enclosure, :map
      add :block, :boolean, default: false, null: false, comment: "Prevent the item from showing"
      add :published_at, :datetime

      timestamps
    end

    create index(:feed_items, [:uuid], unique: true)
  end
end
