defmodule Crex.Mailer do
  use Swoosh.Mailer, otp_app: :crex

  defmodule TestMail do
    import Swoosh.Email

    def welcome(email) do
      new()
      |> to(email)
      |> from(Crex.service_info().mail_from)
      |> subject("Welcome!")
      |> html_body("""

      #{QRCode.create!("https://312b30e8.ngrok.io/r/3829291389101290138") |> QRCode.Svg.create()}
      """)
    end
  end

  def send_testmail() do
    TestMail.welcome("kwando@merciless.me")
    |> deliver!()
  end
end
