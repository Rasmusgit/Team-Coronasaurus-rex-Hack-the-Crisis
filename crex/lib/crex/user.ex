defmodule Crex.User do
  use ParamSchema
  @derive {Jason.Encoder, only: [:id, :name, :phone, :email, :registered_at]}

  embedded_schema do
    field(:id, :string)
    field(:name, :string)
    field(:phone, :string)
    field(:email, :string)
    field(:password, :string)
    field(:registered_at, :utc_datetime)
    field(:businesses, {:map, :string}, default: [])
  end

  def validate(changest) do
    changest
    |> validate_required([:email, :password, :registered_at, :id])
    |> update_change(:password, fn new_password -> Bcrypt.hash_pwd_salt(new_password) end)
  end

  def verify_password(%{password: encrypted_password}, password) do
    Bcrypt.verify_pass(password, encrypted_password)
  end
end
