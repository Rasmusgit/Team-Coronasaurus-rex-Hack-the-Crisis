defmodule Crex.Action do
  defmacro __using__(_) do
    quote do
      use ParamSchema
      require Logger
      alias Crex.InputTypes

      def execute(params, context \\ %{}) do
        with {:ok, input} <- create(params) do
          Logger.debug("process #{__MODULE__}")
          process(input, context)
        end
      end
    end
  end
end
