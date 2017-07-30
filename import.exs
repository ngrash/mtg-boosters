alias MagicLimiter.Repo
alias MagicLimiter.Cards.Card

json = File.read!("AllSetsArray.json") |> Poison.decode!
for set <- json do
  for card <- set["cards"] do
    IO.inspect(card)
    changeset = Card.changeset(%Card{}, %{
      id: card["id"],
      set: set["code"],
      name: card["name"],
      names: card["names"],
      rarity: card["rarity"],
    })
    IO.inspect(Repo.insert(changeset))
  end
end
