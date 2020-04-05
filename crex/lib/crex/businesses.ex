defmodule Crex.Businesses do
  alias Crex.Storage

  defmodule Query do
    use ParamSchema
    alias Crex.InputTypes

    embedded_schema do
      field(:city, InputTypes.UpperCaseString)
      field(:search, InputTypes.TrimmedString)
      field(:type, InputTypes.LowerCaseString)
    end
  end

  def create(params) do
    id = Crex.Utils.generate_id()

    business =
      Crex.Business.create!(params)
      |> Map.put(:id, id)

    Crex.Storage.put({:business, id}, business)
    {:ok, business}
  end

  def find(id) do
    get(id)
    |> case do
      nil -> :error
      value -> {:ok, value}
    end
  end

  def get(id) do
    Crex.Storage.get({:business, id})
  end

  def get_all(params) do
    with {:ok, query} <- Query.create(params) do
      {:ok, base_query} = Crex.Storage.all(Crex.Business)

      Enum.reduce(Query.to_list(query), base_query, fn
        {_, nil}, query ->
          query

        {:city, city}, query ->
          city = String.upcase(city)
          Enum.filter(query, &(&1.city === city))

        {:type, type}, query ->
          type = String.downcase(type)
          Enum.filter(query, &(String.downcase(&1.type) === type))

        {:search, term}, query ->
          Enum.sort_by(query, &FuzzyCompare.similarity(&1.name, term), :desc)
      end)
      |> wrap_ok()
    end
  end

  defp wrap_ok(value), do: {:ok, value}

  if Mix.env() != :prod do
    def clear!() do
      {:ok, keys} =
        Storage.select(
          min_key: {:business, []},
          max_key: {:businessa, []},
          pipe: [map: &elem(&1, 0)]
        )

      CubDB.delete_multi(Storage, keys)
      :ok
    end
  end
end
