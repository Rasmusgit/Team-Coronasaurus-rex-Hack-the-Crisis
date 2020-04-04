defmodule Gravatar do
  def gravatar_url(email) do
    md5 = Crex.Utils.md5(email)
    "https://www.gravatar.com/avatar/#{md5}"
  end
end
