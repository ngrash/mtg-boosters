defmodule MagicLimiter.Cards.Set do
  use Ecto.Schema
  import Ecto.Changeset
  alias MagicLimiter.Cards.Set

  schema "sets" do
    field :name, :string
    field :code, :string
    field :magicCardsInfoCode, :string
    has_many :cards, MagicLimiter.Cards.Card

    timestamps()
  end

  @doc false
  def changeset(%Set{} = set, attrs) do
    set
    |> cast(attrs, [:name, :code, :magicCardsInfoCode])
    |> validate_required([:name, :code])
  end
end
