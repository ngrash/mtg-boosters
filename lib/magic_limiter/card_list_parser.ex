defmodule MagicLimiter.CardListParser do
  @doc """
  iex> MagicLimiter.CardListParser.parse("Nissa, Genesis Mage")
  {:ok, [{"Nissa, Genesis Mage", 1}]}

  iex> MagicLimiter.CardListParser.parse("1 Ahn-Crop Crasher")
  {:ok, [{"Ahn-Crop Crasher", 1}]}

  iex> MagicLimiter.CardListParser.parse("1 Kari Zev, Skyship Raider\\n2 Kari Zev's Expertise")
  {:ok, [{"Kari Zev's Expertise", 2}, {"Kari Zev, Skyship Raider", 1}]}

  iex> MagicLimiter.CardListParser.parse("1 Fireball\\n1 Counterlash\\n2 Fireball")
  {:ok, [{"Counterlash", 1}, {"Fireball", 3}]}

  iex> MagicLimiter.CardListParser.parse("foo\\n\\nbar")
  {:ok,[{"bar", 1}, {"foo", 1}]}

  iex> MagicLimiter.CardListParser.parse("")
  {:error, :pool_empty}
  """
  def parse(""), do: {:error, :pool_empty}
  def parse(pool), do: {:ok, do_parse(pool)}

  def do_parse(pool) do
    pool
    |> String.split("\n")
    |> Enum.reduce(%{}, &reducer/2)
    |> Map.to_list
  end

  defp reducer(line, collection) do
    case String.trim(line) do
      "" -> collection
      _  ->
        {name, count} =
          line
          |> String.trim
          |> parse_line

        case Map.get(collection, name) do
          nil -> Map.put(collection, name, count)
          n   -> Map.put(collection, name, count + n)
        end
    end
  end

  defp parse_line(line) do
    %{"count" => n, "name" => name} =
      Regex.named_captures(~r/((?<count>\d+) )?(?<name>.+)/, line)
    case n do
      "" -> {name, 1}
      _  -> {name, String.to_integer(n)}
    end
  end
end
