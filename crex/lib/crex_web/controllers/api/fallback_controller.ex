defmodule CrexWeb.API.FallbackController do
  use CrexWeb, :controller

  def call(conn, {:error, %ParamSchema.ValidationError{} = error}) do
    conn
    |> send_resp(400, inspect(error))
  end
end
