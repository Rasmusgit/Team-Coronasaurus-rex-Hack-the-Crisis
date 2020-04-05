defmodule CrexWeb.Plugs.AuthAPI do
  @behaviour Plug
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> Plug.Conn.fetch_cookies()
    |> load_user()
  end

  defp load_user(%{assigns: %{access_token: token}} = conn) do
    {:ok, user} = Crex.Users.find(token.user_id)

    conn
    |> Plug.Conn.assign(:current_user, user)
  end

  defp load_user(%{req_cookies: %{"access_token" => accces_token}} = conn) do
    with {:ok, token} <- Crex.AccessToken.verify(accces_token) do
      conn
      |> Plug.Conn.assign(:access_token, token)
      |> load_user()
    else
      error ->
        Logger.debug("authentication failed #{inspect(error)}")

        conn
        |> not_authenticated()
    end
  end

  defp load_user(conn), do: not_authenticated(conn)

  defp not_authenticated(conn) do
    conn
    |> Plug.Conn.send_resp(401, "Not Authenticated")
    |> Plug.Conn.halt()
  end
end
