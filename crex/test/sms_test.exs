defmodule SMSTest do
  use ExUnit.Case

  @tag :skip
  test "send sms" do
    Crex.SendSMS.create!(number: "+46708519847", message: "hello world")
    |> Crex.SMS.send_sms()
    |> IO.inspect(label: "sms_result")
  end
end
