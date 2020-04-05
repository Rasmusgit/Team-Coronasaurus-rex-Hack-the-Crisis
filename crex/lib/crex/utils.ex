defmodule Crex.Utils do
  def generate_id(length \\ 20) do
    :crypto.strong_rand_bytes(length)
    |> Base.encode32()
  end

  def md5(content) do
    :crypto.hash(:md5, content)
    |> Base.encode16(case: :lower)
  end
end
