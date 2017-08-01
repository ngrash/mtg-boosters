alias MagicLimiter.Repo
alias MagicLimiter.Cards.Card
alias MagicLimiter.Cards.Set

json = File.read!("AllSetsArray.json") |> Poison.decode!
for set <- json do
  changeset = Set.changeset(%Set{}, %{
    name: set["name"],
    code: set["code"],
    magicCardsInfoCode: set["magicCardsInfoCode"]
  })
  set_id = Repo.insert!(changeset).id

  for card <- set["cards"] do
    IO.inspect(card)
    changeset = Card.changeset(%Card{}, %{
      id: card["id"],
      set_id: set_id,
      name: card["name"],
      names: card["names"],
      number: card["number"],
      rarity: card["rarity"],
    })
    IO.inspect(Repo.insert(changeset))
  end
end
