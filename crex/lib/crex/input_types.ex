defmodule Crex.InputTypes do
  defmodule LowerCaseString do
    def type(), do: :string
    def cast(value) when is_binary(value) do
      {:ok, value |> String.trim() |> String.downcase()}
    end

    def cast(_), do: :error
  end

  defmodule UpperCaseString do
    def type(), do: :string
    def cast(value) when is_binary(value) do
      {:ok, value |> String.trim() |> String.upcase()}
    end

    def cast(_), do: :error
  end

  defmodule TrimmedString do
    def type(), do: :string
    def cast(value) when is_binary(value) do
      {:ok, value |> String.trim()}
    end

    def cast(_), do: :error
  end
end
