defmodule CrexWeb.DBController do
  use CrexWeb, :controller

  def index(conn, _params) do
    {:ok, records} = CubDB.select(Crex.Storage)

    conn
    |> text(inspect(records, pretty: true))
  end
end
