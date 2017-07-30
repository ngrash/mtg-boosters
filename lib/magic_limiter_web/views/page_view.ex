defmodule MagicLimiterWeb.PageView do
  use MagicLimiterWeb, :view

  alias MagicLimiter.Cards.Card

  def render_card(%Card{name: name, rarity: rarity}) do
    "#{name} (#{rarity})"
  end

  def render_card({:ok, card, count}) do
    "#{count} x #{card.name} (#{card.rarity})"
  end

  def render_card({:error, {:not_found, name}, count}) do
    "#{count} x #{name} (unknown)"
  end
end
