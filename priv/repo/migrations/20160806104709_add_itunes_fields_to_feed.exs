defmodule PodcatApi.Repo.Migrations.AddItunesFieldsToFeed do
  use Ecto.Migration

  def change do
    alter table(:feeds) do
      add :title, :string, comment: "Name of the feed"
      add :subtitle, :string, comment: "Description of the feed, only a few words long"
      add :copyright, :string
      add :block, :boolean, default: false, comment: "Prevent an feed from appearing"
      add :explicit, :integer, default: 0, comment: "0 = no, 1 = yes, 2 = clean"
    end

    rename table(:feeds), :homepage, to: :link
  end
end
