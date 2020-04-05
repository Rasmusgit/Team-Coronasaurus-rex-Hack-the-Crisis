defmodule Crex.Storage do
  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [[]]}
    }
  end

  @env Mix.env()
  def start_link([]) do
    CubDB.start_link(data_dir: Path.join(["data", to_string(@env)]), name: __MODULE__)
  end

  def get_card(identifier) do
    fetch({:gift_card, identifier})
  end

  def get_all_cards() do
    CubDB.select(__MODULE__, min_key: {:gift_card, ""}, pipe: [map: &elem(&1, 1)])
  end

  def get_cards_for_user(owner_id) do
    CubDB.select(__MODULE__,
      min_key: {:gift_card, []},
      max_key: {:gift_carda, []},
      pipe: [
        filter: fn {_id, card} -> card.owner === owner_id end,
        map: &elem(&1, 1)
      ]
    )
  end

  def exists?(key) do
    fetch(key) != :error
  end

  def store(%Crex.GiftCard{identifier: identifier, version: new_version} = card) do
    key = {:gift_card, identifier}

    fetch(key)
    |> case do
      :error ->
        put(key, card)
        {:ok, card}

      {:ok, existing_card} ->
        if existing_card.version > new_version do
          {:error, :stale_data}
        else
          put(key, card)
          {:ok, card}
        end
    end
  end

  def get(key) do
    CubDB.get(__MODULE__, key)
  end

  def all(Crex.Business) do
    select(
      min_key: {:business, ""},
      max_key: {:businessa, ""},
      pipe: [
        filter: fn {key, _value} -> match?({:business, _}, key) end,
        map: &elem(&1, 1)
      ]
    )
  end

  def storage_key(%Crex.Business{id: id}), do: {:business, id}
  def storage_key(%Crex.User{id: id}), do: {:user, id}

  def fetch(key), do: CubDB.fetch(__MODULE__, key)
  def put(key, value), do: CubDB.put(__MODULE__, key, value)
  def select(opts), do: CubDB.select(__MODULE__, opts)
end
