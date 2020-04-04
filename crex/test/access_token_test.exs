defmodule AccessTokenTest do
  use ExUnit.Case

  test "access_token" do
    token = Crex.AccessToken.create(32819)

    assert {:ok, %{user_id: 32819}} = Crex.AccessToken.verify(token)
  end
end
