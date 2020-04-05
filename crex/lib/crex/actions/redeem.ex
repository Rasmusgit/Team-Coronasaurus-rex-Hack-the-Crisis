defmodule Crex.Actions.Redeem do
  use Crex.Action
  alias Crex.{GiftCards, GiftCard}

  embedded_schema do
    field(:gift_card, InputTypes.TrimmedString)
    field(:amount, :integer)
    field(:description, InputTypes.TrimmedString)
  end

  def validate(changeset) do
    changeset
    |> validate_required([:gift_card, :amount, :description])
    |> validate_number(:amount, greater_than: 0)
    |> validate_exists(:gift_card, :gift_card)
  end

  defp process(action, _ct) do
    {:ok, card} = GiftCards.find(action.gift_card)

    GiftCard.redeem(card, action.amount, action.description)
    |> case do
      {:ok, card} ->
        Crex.Storage.store(card)

      {:insufficient_amount, gift_card} ->
        {:error,
         %Crex.Error{
           message: "GiftCard had not enough value"
         }}
    end
  end
end
