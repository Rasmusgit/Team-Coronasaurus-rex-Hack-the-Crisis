defmodule CrexWeb.API.CommandController do
  require Logger
  use CrexWeb, :controller
  plug(:map_command)

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
        |> json(render_errors(validation_error.errors))

      {:ok, value} ->
        conn
        |> put_status(200)
        |> json(value)
    end
  end

  defp map_command(%{assigns: %{command: command}} = conn, _opts) when is_atom(command), do: conn

  defp map_command(%{params: %{"command" => command_key}} = conn, _opts) do
    Map.fetch(@commands, command_key)
    |> case do
      {:ok, command} ->
        conn
        |> assign(:command, command)

      :error ->
        not_found(conn)
    end
  end

  defp map_command(conn, _opts) do
    IO.inspect(conn, label: "no command")

    not_found(conn)
  end

  defp not_found(conn) do
    conn
    |> send_resp(404, "Not Found")
    |> halt()
  end

  defp render_errors(errors) do
    %{
      error: %{
        code: 422,
        message: "invalid params",
        data: errors
      }
    }
  end
end
