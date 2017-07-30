defmodule MagicLimiter.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset
  alias MagicLimiter.Cards.Card

  @primary_key {:id, :string, []}

  schema "cards" do
    field :set, :string
    field :name, :string
    field :names, {:array, :string}
    field :rarity, :string

    timestamps()
  end

  @doc false
  def changeset(%Card{} = card, attrs) do
    card
    |> cast(attrs, [:id, :set, :name, :names, :rarity])
    |> unique_constraint(:id, name: :cards_pkey)
    |> validate_required([:set, :name, :rarity])
  end
end
