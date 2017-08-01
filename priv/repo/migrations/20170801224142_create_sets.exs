defmodule MagicLimiter.Repo.Migrations.CreateSets do
  use Ecto.Migration

  def change do
    create table(:sets) do
      add :name, :string
      add :code, :string
      add :magicCardsInfoCode, :string

      timestamps()
    end

  end
end
