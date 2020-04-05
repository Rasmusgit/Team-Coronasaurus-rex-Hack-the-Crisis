defmodule ParamSchema do
  defmodule ValidationHelpers do
    def validate_exists(changeset, field, _namespace) do
      changeset
      |> Ecto.Changeset.validate_change(field, fn
        :owner, user_id ->
          Crex.Users.find(user_id)
          |> case do
            {:ok, _} -> []
            _ -> [owner: "no user with that id"]
          end

        :business, business_id ->
          Crex.Businesses.find(business_id)
          |> case do
            {:ok, _} -> []
            _ -> [business: "no business with that id"]
          end

        :gift_card, card_id ->
          Crex.GiftCards.find(card_id)
          |> case do
            {:ok, _} -> []
            _ -> [gift_card: "no such gift_card"]
          end
      end)
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
    {:error, %ValidationError{errors: traverse_errors(changeset), changeset: changeset}}
  end

  defp cast_embeds(changeset, []), do: changeset

  defp cast_embeds(changeset, [embed | embeds]) do
    changeset
    |> Ecto.Changeset.cast_embed(embed)
    |> cast_embeds(embeds)
  end

  defp traverse_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
