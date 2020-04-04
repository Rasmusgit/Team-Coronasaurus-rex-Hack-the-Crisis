defmodule CrexWeb.PageController do
  use CrexWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
