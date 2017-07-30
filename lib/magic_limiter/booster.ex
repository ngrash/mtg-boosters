defmodule MagicLimiter.Booster do
  def build(pool, count) do
    pool
    |> denormalize
    |> order_by_rarity
    |> pack(count)
  end

  defp denormalize(pool) do
    Enum.flat_map(pool, fn {card, count} ->
      List.duplicate(card, count)
    end)
  end

  defp pack(pool, count), do: do_pack([], pool, count)
  defp do_pack(boosters, _, 0), do: boosters
  defp do_pack(boosters, pool, count) do
    {booster, remaining_cards} = pack_booster(pool)
    do_pack(boosters ++ [booster], remaining_cards, count - 1)
  end

  defp pack_booster({c, u, r, m}) do
    # c = commons
    # cb = commons in booster
    # cr = commons remaining (in pool)
    {cb, cr} = pop_random(c, 10)
    {ub, ur} = pop_random(u, 3)
    {rb, rr, mr} = pick_rare(r, m)
    {cb ++ ub ++ rb, {cr, ur, rr, mr}}
  end

  defp pick_rare(rares, mythics) do
    cond do
      Enum.random(1..8) == 1 && mythics != [] ->
        {mythic_in_booster, remaining_mythics} = pop_random(mythics, 1)
        {mythic_in_booster, rares, remaining_mythics}
      true ->
        {rare_in_booster, remaining_rares} = pop_random(rares, 1)
        {rare_in_booster, remaining_rares, mythics}
    end
  end

  defp pop_random(list, n) do
    shuffled = Enum.shuffle(list)
    values = Enum.take(shuffled, n)
    {values, pop(shuffled, n)}
  end

  defp pop(list, 0), do: list
  defp pop([_ | rest], n), do: pop(rest, n - 1)

  defp order_by_rarity(pool) do
    Enum.reduce(pool, {[], [], [], []}, fn card, {c, u, r, m} ->
      case card.rarity do
        "Common"      -> {c ++ [card], u, r, m}
        "Uncommon"    -> {c, u ++ [card], r, m}
        "Rare"        -> {c, u, r ++ [card], m}
        "Mythic Rare" -> {c, u, r, m ++ [card]}
      end
    end)
  end
end
