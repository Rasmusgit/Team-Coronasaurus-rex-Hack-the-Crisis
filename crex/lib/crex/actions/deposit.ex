defmodule Crex.Actions.Deposit do
  use Crex.Action

  embedded_schema do
    field :business, :string
    field :owner, :string
    field :amount, :integer
  end

  def validate(changeset) do
    changeset
    |> validate_required([:business, :owner, :amount])
    |> validate_number(:amount, greater_than: 0)
    |> validate_exists(:owner, :owners)
    |> validate_exists(:business, :business)
  end

  def validate_exists(changeset, field, _namespace) do
    changeset
    |> validate_change(field, fn
      :owner, user_id ->
        Crex.Users.find(user_id)
        |> case do
          {:ok, _} -> []
          _ -> [owner: "no user with that id"]
        end

      :business, business_id ->
        Crex.Businesses.find(business_id)
        |> case do
          {:ok, _} -> []
          _ -> [business: "no business with that id"]
        end
    end)
  end

  defp process(deposit) do
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
