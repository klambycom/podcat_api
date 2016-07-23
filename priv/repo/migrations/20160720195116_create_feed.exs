defmodule Reader.Repo.Migrations.CreateFeed do
  use Ecto.Migration

  def change do
    create table(:feeds) do

      timestamps()
    end

  end
end
