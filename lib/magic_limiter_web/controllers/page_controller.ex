defmodule MagicLimiterWeb.PageController do
  use MagicLimiterWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
