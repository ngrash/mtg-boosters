defmodule MagicLimiter.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards, primary_key: false) do
      add :id, :string, primary_key: true
      add :set, :string
      add :name, :string
      add :names, {:array, :string}
      add :rarity, :string

      timestamps()
    end

  end
end
