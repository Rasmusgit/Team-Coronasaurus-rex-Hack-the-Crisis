defmodule Crex.Actions.Redeem do
  use Crex.Action

  embedded_schema do
    field :gift_card, InputTypes.TrimmedString
    field :amount, :integer
    field :description, InputTypes.TrimmedString
  end


  def validate(changeset) do
    changeset
    |> validate_required([:gift_card, :amount, :description])
    |> validate_number(:amount, greater_than: 0)
  end

  defp process(action) do

  end
end
