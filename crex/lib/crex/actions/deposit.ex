defmodule Crex.Actions.Deposit do
  use Crex.Action

  embedded_schema do
    field(:business, :string)
    field(:owner, :string)
    field(:amount, :integer)
  end

  def validate(changeset) do
    changeset
    |> validate_required([:business, :owner, :amount])
    |> validate_number(:amount, greater_than: 0)
    |> validate_exists(:owner, :owners)
    |> validate_exists(:business, :business)
  end

  defp process(deposit, _ctx) do
    {:ok, existing_cards} = Crex.Storage.get_cards_for_user(deposit.owner)

    card =
      Enum.find(
        existing_cards,
        Crex.GiftCard.new(business: deposit.business, owner: deposit.owner),
        fn card -> card.business === deposit.business end
      )

    {:ok, card} = Crex.GiftCard.deposit(card, deposit.amount)
    Crex.Storage.store(card)
  end
end
