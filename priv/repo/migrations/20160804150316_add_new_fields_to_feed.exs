defmodule Reader.Repo.Migrations.AddNewFieldsToFeed do
  use Ecto.Migration

  def change do
    alter table(:feeds) do
      add :author, :string
      add :image_url, :string, comment: "Url to image with highest size"
    end

    rename table(:feeds), :name, to: :summary
    rename table(:feeds), :rss_feed, to: :feed_url

    create index(:feeds, [:feed_url], unique: true)
  end
end
