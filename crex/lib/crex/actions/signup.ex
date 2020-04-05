defmodule Crex.Actions.Signup do
  use Crex.Action
  alias Crex.{Users, User}

  embedded_schema do
    field(:email, InputTypes.LowerCaseString)
    field(:password, :string)
  end

  def validate(changeset) do
    changeset
    |> validate_required([:email, :password])
  end

  defp process(record, _ctx) do
    if Users.email_registered?(record.email) do
      {:error, %Crex.Error{message: "User already exists"}}
    else
      Users.store(
        User.create!(
          id: Crex.Utils.generate_id(),
          email: record.email,
          password: record.password,
          registered_at: DateTime.utc_now()
        )
      )
    end
  end
end
