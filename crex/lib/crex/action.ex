defmodule Crex.Action do
  defmacro __using__(_) do
    quote do
      use ParamSchema
      alias Crex.InputTypes

      def execute(params) do
        with {:ok, input} <- create(params) do
          process(input)
        end
      end
    end
  end
end
