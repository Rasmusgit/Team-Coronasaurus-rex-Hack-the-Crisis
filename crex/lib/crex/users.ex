defmodule Crex.Users do
  alias Crex.Storage
  def find(user_id) do
    Crex.Storage.get({:user, user_id})
    |> case do
      nil -> {:error, {:missing_user, user_id}}
      user -> {:ok, user}
    end
  end

  def authenticate(email, password) do
    Storage.fetch(email_record(%{email: email}))
    |> case do
      {:ok, user_id} ->
        {:ok, user} = find(user_id)
        if Crex.User.verify_password(user, password) do
          {:ok, user}
        else
          {:error, :wrong_password}
        end
        :error ->
          {:error, :missing_user}
    end
  end

  def store(%Crex.User{id: identifier} = user) do

    Storage.put({:user, identifier}, user)
    Storage.put(email_record(user), identifier)
    {:ok, user}
  end

  def email_registered?(email) do
    Storage.exists?(email_record(%{email: email}))
  end

  defp email_record(%{email: email}), do: {:user_email, email}
end
