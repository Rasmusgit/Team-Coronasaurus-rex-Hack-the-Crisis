defmodule Crex.SendSMS do
  use ParamSchema

  embedded_schema do
    field :message, :string
    field :number, :string
  end

  def validate(changeset) do
    changeset
    |> validate_required([:message, :number])
    |> validate_format(:number, ~r/^\+\d{11}$/)
  end
end
