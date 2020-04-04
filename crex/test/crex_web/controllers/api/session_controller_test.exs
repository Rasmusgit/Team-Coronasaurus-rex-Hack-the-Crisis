
defmodule CrexWeb.SessionControllerTest do
  use CrexWeb.ConnCase

  describe "POST /api/session" do
    test "with valid credentials", %{conn: conn} do
      user = Crex.User.create!(email: "kwando@merciless.me", password: "hello", registered_at: DateTime.utc_now(), id: Crex.Utils.generate_id())
      Crex.Users.store(user)

      conn = post(conn, "/api/session", %{"email" => "kwando@merciless.me", "password" => "hello"})
      assert %{"access_token" => _token} = json_response(conn, 200)
    end

    test "with invalid credentials", %{conn: conn} do
      user = Crex.User.create!(email: "kwando@merciless.me", password: "hello1", registered_at: DateTime.utc_now(), id: Crex.Utils.generate_id())
      Crex.Users.store(user)

      conn = post(conn, "/api/session", %{"email" => "kwando@merciless.me", "password" => "hello"})
      assert conn.status === 422
    end
  end
end
