defmodule MagicLimiter.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset
  alias MagicLimiter.Cards.Card

  @primary_key {:id, :string, []}

  schema "cards" do
    field :name, :string
    field :names, {:array, :string}
    field :number, :string
    field :rarity, :string
    belongs_to :set, MagicLimiter.Cards.Set

    timestamps()
  end

  @doc false
  def changeset(%Card{} = card, attrs) do
    card
    |> cast(attrs, [:id, :set_id, :name, :names, :number, :rarity])
    |> unique_constraint(:id, name: :cards_pkey)
    |> validate_required([:set_id, :name, :rarity])
  end
end
