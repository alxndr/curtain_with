defmodule CurtainWith.Repo.Migrations.CreateHouse do
  use Ecto.Migration

  def change do
    create table(:houses) do
      add :name, :string
      add :book, :map

      timestamps()
    end

  end
end
