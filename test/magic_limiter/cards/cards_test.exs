defmodule MagicLimiter.CardsTest do
  use MagicLimiter.DataCase

  alias MagicLimiter.Cards

  describe "cards" do
    alias MagicLimiter.Cards.Card

    @valid_attrs %{name: "some name", names: [], rarity: "some rarity"}
    @update_attrs %{name: "some updated name", names: [], rarity: "some updated rarity"}
    @invalid_attrs %{name: nil, names: nil, rarity: nil}

    def card_fixture(attrs \\ %{}) do
      {:ok, card} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Cards.create_card()

      card
    end

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert Cards.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert Cards.get_card!(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      assert {:ok, %Card{} = card} = Cards.create_card(@valid_attrs)
      assert card.name == "some name"
      assert card.names == []
      assert card.rarity == "some rarity"
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cards.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()
      assert {:ok, card} = Cards.update_card(card, @update_attrs)
      assert %Card{} = card
      assert card.name == "some updated name"
      assert card.names == []
      assert card.rarity == "some updated rarity"
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = Cards.update_card(card, @invalid_attrs)
      assert card == Cards.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = Cards.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> Cards.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = Cards.change_card(card)
    end
  end
end
