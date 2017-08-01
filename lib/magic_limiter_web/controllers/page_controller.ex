defmodule MagicLimiterWeb.PageController do
  use MagicLimiterWeb, :controller

  alias MagicLimiter.CardListParser
  alias MagicLimiter.{Cards, Booster}

  def index(conn, _params) do
    render conn, "index.html"
  end

  def faq(conn, _params) do
    render conn, "faq.html"
  end

  def create(conn, %{"pool_params" => pool_params}) do
    case CardListParser.parse(String.trim(pool_params["card_list"])) do
      {:ok, pool} ->
        known_cards = pool
          |> find_cards
          |> Enum.filter(fn {status, _, _} -> status == :ok end)
          |> Enum.map(fn {_, card, count} -> {card, count} end)

        desired_booster_count = String.to_integer(pool_params["number_of_boosters"])
        cards_by_rarity = Booster.count_rarity(known_cards)
        max_possible_boosters = Booster.max_possible_boosters(cards_by_rarity)

        count = case max_possible_boosters > desired_booster_count do
          true  -> desired_booster_count
          false ->

            conn = put_flash(conn, :warning, "You asked for #{desired_booster_count} boosters but you card pool only allows for #{max_possible_boosters}.")
            max_possible_boosters
        end

        boosters = Booster.build(known_cards, count)

        render conn, "pool.html", cards: find_cards(pool), boosters: Enum.with_index(boosters)
      {:error, :pool_empty} ->
        conn
        |> put_flash(:error, "Please enter your pool below")
        |> redirect(to: page_path(conn, :index))
    end
  end

  defp find_cards(pool) do
    Enum.map(pool, fn {name, count} ->
      case Cards.find_card(name) do
        nil  -> {:error, {:not_found, name}, count}
        card -> {:ok, card, count}
      end
    end)
  end
end
