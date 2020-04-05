defmodule GiftCardTest do
  use ExUnit.Case, async: true
  alias Crex.GiftCard

  test "flow" do
    card = Crex.GiftCard.new(business: "420", owner: "8932")

    {:ok, card} =
      card
      |> GiftCard.deposit(4210)

    assert GiftCard.current_value(card) === 4210

    {:ok, card} =
      card
      |> GiftCard.deposit(300)

    assert GiftCard.current_value(card) === 4510

    {:ok, card} =
      card
      |> GiftCard.redeem(3520, "Donation")

    assert GiftCard.current_value(card) === 990
  end
end
