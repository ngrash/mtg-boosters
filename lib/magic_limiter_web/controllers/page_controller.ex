defmodule MagicLimiterWeb.PageController do
  use MagicLimiterWeb, :controller

  alias MagicLimiter.CardListParser

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, %{"pool_params" => pool_params}) do
    case CardListParser.parse(String.trim(pool_params["card_list"])) do
      {:ok, pool} ->
        render conn, "pool.html", cards: pool
      {:error, :pool_empty} ->
        conn
        |> put_flash(:error, "Please enter a pool below")
        |> redirect(to: page_path(conn, :index))
    end
  end
end
