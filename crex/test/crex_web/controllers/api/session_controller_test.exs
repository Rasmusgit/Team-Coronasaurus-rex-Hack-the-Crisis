defmodule CrexWeb.SessionControllerTest do
  use CrexWeb.ConnCase

  describe "POST /api/session" do
    test "with valid credentials", %{conn: conn} do
      setup_user()

      conn =
        post(conn, "/api/session", %{"email" => "kwando@merciless.me", "password" => "hello"})

      assert %{"access_token" => _token} = json_response(conn, 200)
    end

    test "with invalid credentials", %{conn: conn} do
      setup_user()

      conn =
        post(conn, "/api/session", %{"email" => "kwando@merciless.me", "password" => "hello 3020"})

      assert conn.status === 422
    end
  end

  defp setup_user() do
    user =
      Crex.User.create!(
        email: "kwando@merciless.me",
        password: "hello",
        registered_at: DateTime.utc_now(),
        id: Crex.Utils.generate_id()
      )

    {:ok, user} = Crex.Users.store(user)
    {:ok, user}
  end
end
