defmodule MagicLimiterWeb.PageView do
  use MagicLimiterWeb, :view

  alias MagicLimiter.Cards.Card

  def render_card(%Card{} = card) do
    Phoenix.HTML.raw(card_link(card))
  end

  def render_card({:ok, card, count}) do
    Phoenix.HTML.raw("#{count} x #{card_link(card)}")
  end

  def render_card({:error, {:not_found, name}, count}) do
    "#{count} x #{name} (unknown)"
  end

  defp card_link(%Card{name: name, rarity: rarity, number: number, set: %{magicCardsInfoCode: code}}) do
    "<a href=\"http://magiccards.info/#{code}/en/#{number}.html\">#{name} (#{rarity})</a>"
  end
end
