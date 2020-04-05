defmodule CommandControllerTest do
  use CrexWeb.ConnCase

  test "unauthenitcated command", %{conn: conn} do
    conn =
      conn
      |> post("/api/ping")

    assert conn.status == 401
  end

  describe "POST /api/signup" do
    test " with valid data", %{conn: conn} do
      conn =
        conn
        |> post("/api/signup", %{
          email: Faker.Internet.email(),
          password: "hello world"
        })

      assert conn.status == 200, inspect(conn.resp_body, pretty: true)
    end

    test " with invalid ", %{conn: conn} do
      conn =
        conn
        |> post("/api/signup", %{
          email: Faker.Internet.email()
        })

      assert conn.status == 422, inspect(conn.resp_body, pretty: true)
    end
  end

  describe "POST /api/ping" do
    test "", %{conn: conn} do
      conn =
        conn
        |> post("/api/ping", %{})

      assert conn.status == 200, inspect(conn.resp_body, pretty: true)
    end
  end
end
