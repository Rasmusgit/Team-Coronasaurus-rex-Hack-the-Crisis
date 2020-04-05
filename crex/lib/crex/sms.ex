defmodule Crex.SMS do
  def send_sms(%Crex.SendSMS{} = request) do
    url = "https://api.46elks.com/a1/SMS"
    username = "u8401acd8cfce10d2fdb3c621460b6e1f"
    password = "8F4BA06F079D8EFDBF1586B84D839B76"

    credentials = Base.encode64("#{username}:#{password}")

    with {:ok, %{status_code: 200}} <-
           HTTPoison.post(
             url,
             {:form,
              [
                {"from", Crex.service_info().sms_from},
                {"to", request.number},
                {"message", request.message}
              ]},
             [{"Authorization", "Basic #{credentials}≠"}]
           ) do
      :ok
    else
      {:ok, response} ->
        {:error, {:sms_error, response}}

      error ->
        error
    end
  end
end
