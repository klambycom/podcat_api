defmodule Reader.Repo.Migrations.IncreaseSizeOnSummaryAndDescriptionInFeed do
  use Ecto.Migration

  def change do
    alter table(:feeds) do
      modify :summary, :text, null: false
      modify :description, :text
    end
  end
end
