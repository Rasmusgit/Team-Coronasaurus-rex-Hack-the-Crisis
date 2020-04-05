defmodule Crex.Actions.Ping do
  use Crex.Action

  embedded_schema do
  end

  defp process(action, _ctx) do
    {:ok, "pong"}
  end
end
