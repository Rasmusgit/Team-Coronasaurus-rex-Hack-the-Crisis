defmodule ParamSchema do
  defmodule ValidationHelpers do
    def validate_subset1(changeset, key, values) do
      Ecto.Changeset.get_field(changeset, key)
      |> case do
        nil ->
          changeset

        selected_values ->
          Enum.split_with(selected_values, &Enum.member?(values, &1))
          |> IO.inspect(label: "hello")

          changeset
      end
    end
  end

  defmodule ValidationError do
    defexception message: "Validation error", errors: [], changeset: nil
  end

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import ParamSchema.ValidationHelpers
      @primary_key false

      def create(params), do: ParamSchema.create(__MODULE__, params)
      def create!(params), do: ParamSchema.create!(__MODULE__, params)

      def changeset(data, params), do: ParamSchema.changeset(__MODULE__, data, params)

      def validate(changeset) do
        changeset
      end

      def to_list(record) do
        Map.from_struct(record) |> Map.to_list()
      end

      defoverridable validate: 1
    end
  end

  def create(module, params) do
    changeset(module, struct(module), params)
    |> build_return()
  end

  def create!(module, params) do
    case create(module, params) do
      {:ok, input} -> input
      {:error, error} -> raise %{error | message: "ValidationError: #{inspect(error.errors)}"}
    end
  end

  def changeset(module, data, params) when is_list(params),
    do: changeset(module, data, Map.new(params))

  def changeset(module, data, params) do
    embeds = module.__schema__(:embeds)
    fields = module.__schema__(:fields) -- embeds

    Ecto.Changeset.cast(data, params, fields)
    |> cast_embeds(embeds)
    |> module.validate()
  end

  def build_return(%{valid?: true} = changeset) do
    {:ok, Ecto.Changeset.apply_changes(changeset)}
  end

  def build_return(%{valid?: false} = changeset) do
    {:error, %ValidationError{errors: extract_errors(changeset), changeset: changeset}}
  end

  def extract_errors(%{valid?: false} = changeset) do
    embedded_errors =
      Enum.filter(changeset.types, fn
        {_, {:embed, _embed}} -> true
        _ -> false
      end)
      |> Enum.map(&elem(&1, 0))
      |> Enum.map(fn key ->
        embed_errors =
          Ecto.Changeset.get_change(changeset, key)
          |> extract_errors()

        {key, embed_errors}
      end)
      |> Enum.reject(&match?({_, []}, &1))

    Map.new(changeset.errors ++ embedded_errors)
  end

  def extract_errors(_), do: []

  defp cast_embeds(changeset, []), do: changeset

  defp cast_embeds(changeset, [embed | embeds]) do
    changeset
    |> Ecto.Changeset.cast_embed(embed)
    |> cast_embeds(embeds)
  end
end
