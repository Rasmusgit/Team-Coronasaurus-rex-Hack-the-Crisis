defmodule Crex.SMS do
  def send_twilio_sms(phone_number, message) do
    account_sid = "ACd302da531fbe8488ecfb81de908adfdf"
    auth_token = "07c2f58daac6d7b42d9b465a29d6703f"
    twilio_number = "+19412601137"

    credentials = Base.encode64("#{account_sid}:#{auth_token}")

    HTTPoison.post(
      "https://api.twilio.com/2010-04-01/Accounts/#{account_sid}/Messages",
      {:form,
       [
         {"From", twilio_number},
         {"To", phone_number},
         {"Body", message}
       ]},
      [
        {"Authorization", "Basic #{credentials}"}
      ]
    )
    |> IO.inspect(label: "result", pretty: true)
  end

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
