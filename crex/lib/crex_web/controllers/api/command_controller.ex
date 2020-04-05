defmodule CrexWeb.API.CommandController do
  require Logger
  use CrexWeb, :controller
  # plug(:map_command)

  @commands %{
    "ping" => CrexWeb.Actions.Ping,
    "deposit" => CrexWeb.Actions.Deposit,
    "redeem" => CrexWeb.Actions.Redeem,
    "register_business" => CrexWeb.Actions.RegisterBusiness
  }

  def execute(%{assigns: %{command: command}} = conn, params) do
    command.execute(params, conn.assigns)
    |> case do
      {:error, %ParamSchema.ValidationError{} = validation_error} ->
        conn
        |> put_status(422)
        |> text(inspect(validation_error.errors))

      {:ok, value} ->
        conn
        |> put_status(200)
        |> json(value)
    end
  end

  defp map_command(%{assigns: %{command: command}} = conn), do: conn

  defp map_command(%{params: %{"command" => command_key}} = conn) do
    command = Map.fetch!(@commands, command_key)

    conn
    |> assign(:command, command)
  end

  defp map_command(conn, _opts) do
    conn
    |> send_resp(404, "Not Found")
    |> halt()
  end
end
