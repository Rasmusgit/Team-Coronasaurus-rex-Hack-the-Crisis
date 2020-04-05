defmodule Crex.Utils do
  def generate_id() do
    :crypto.strong_rand_bytes(20)
    |> Base.encode32()
  end

  def md5(content) do
    :crypto.hash(:md5, content)
    |> Base.encode16(case: :lower)
  end
end
