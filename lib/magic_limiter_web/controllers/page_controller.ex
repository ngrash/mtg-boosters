defmodule MagicLimiterWeb.PageController do
  use MagicLimiterWeb, :controller

  alias MagicLimiter.CardListParser
  alias MagicLimiter.{Cards, Booster}

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, %{"pool_params" => pool_params}) do
    case CardListParser.parse(String.trim(pool_params["card_list"])) do
      {:ok, pool} ->
        known_cards = pool
          |> find_cards
          |> Enum.filter(fn {status, _, _} -> status == :ok end)
          |> Enum.map(fn {_, card, count} -> {card, count} end)

        boosters = Booster.build(known_cards, String.to_integer(pool_params["number_of_boosters"]))

        render conn, "pool.html", cards: find_cards(pool), boosters: boosters
      {:error, :pool_empty} ->
        conn
        |> put_flash(:error, "Please enter a pool below")
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
