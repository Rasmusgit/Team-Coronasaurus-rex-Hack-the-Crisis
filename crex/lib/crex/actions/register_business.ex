defmodule Crex.Actions.RegisterBusiness do
  use Crex.Action

  embedded_schema do
    field :name, InputTypes.TrimmedString
    field :description, InputTypes.TrimmedString
    field :city, InputTypes.UpperCaseString
    field :image_url,InputTypes.TrimmedString
  end

  def validate(changeset) do
    changeset
    |> validate_required([:name, :city])
  end

  def process(record) do
    Crex.Businesses.create(Map.from_struct(record))
  end
end
