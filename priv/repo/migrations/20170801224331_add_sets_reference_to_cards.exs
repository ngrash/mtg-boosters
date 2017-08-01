defmodule MagicLimiter.Repo.Migrations.AddSetsReferenceToCards do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :set_id, references(:sets)
    end
  end
end
