defmodule MagicLimiter.CardListParser do
  @doc """
  iex> MagicLimiter.CardListParser.parse("1 Ahn-Crop Crasher")
  [{"Ahn-Crop Crasher", 1}]

  iex> MagicLimiter.CardListParser.parse("1 Kari Zev, Skyship Raider\\n2 Kari Zev's Expertise")
  [{"Kari Zev's Expertise", 2}, {"Kari Zev, Skyship Raider", 1}]

  iex> MagicLimiter.CardListParser.parse("1 Fireball\\n1 Counterlash\\n2 Fireball")
  [{"Counterlash", 1}, {"Fireball", 3}]
  """
  def parse(pool) do
    pool
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, all ->
      {name, count} = parse_line(line)
      case Map.get(all, name) do
        nil -> Map.put(all, name, count)
        n   -> Map.put(all, name, count + n)
      end
    end)
    |> Map.to_list
  end

  defp parse_line(line) do
    %{"count" => n, "name" => name} =
      Regex.named_captures(~r/((?<count>\d+) )?(?<name>.+)/, line)
    {name, String.to_integer(n)}
  end
end
