defmodule PodcatApi.Repo.Migrations.CreateFeed.Category do
  use Ecto.Migration

  def change do
    create table(:feed_categories) do
      add :title, :string
      add :summary, :string
      add :slug, :string
      add :itunes_id, :integer
      add :parent_id, references(:feed_categories)

      timestamps()
    end

  end
end
