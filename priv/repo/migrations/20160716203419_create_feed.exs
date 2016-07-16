defmodule Reader.Repo.Migrations.CreateFeed do
  use Ecto.Migration

  def change do
    create table(:feeds) do
      add :name, :string
      add :homepage, :string
      add :description, :string
      add :rss_feed, :string

      timestamps()
    end

  end
end
