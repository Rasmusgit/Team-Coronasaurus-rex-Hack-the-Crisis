defmodule Crex.AccessToken do
  defstruct [:user_id]

  def create(user_id) do
    Phoenix.Token.sign(CrexWeb.Endpoint, "access_token", %__MODULE__{user_id: user_id})
  end

  def verify(token) do
    Phoenix.Token.verify(CrexWeb.Endpoint, "access_token", token, max_age: 3600)
  end
end
