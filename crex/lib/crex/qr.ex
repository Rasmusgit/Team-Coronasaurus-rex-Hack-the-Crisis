defmodule Crex.QR do
  def generate_code(message) do
    QRCode.create!(message)
    |> QRCode.Svg.create()
  end
end
