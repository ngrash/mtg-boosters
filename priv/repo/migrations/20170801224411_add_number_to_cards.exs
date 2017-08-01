defmodule MagicLimiter.Repo.Migrations.AddNumberToCards do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :number, :string
    end
  end
end
