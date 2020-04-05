defmodule Crex.GiftCard do
  require Record
  defstruct [:identifier, :createdAt, :business, :owner, version: 1, transactions: []]

  Record.defrecordp(:transaction, [:amount, :description, :timestamp])

  def new(opts) do
    %__MODULE__{
      business: Keyword.fetch!(opts, :business),
      owner: Keyword.fetch!(opts, :owner),
      identifier: Crex.Utils.generate_id(5),
      createdAt: DateTime.utc_now(),
      transactions: []
    }
  end

  def current_value(gift_card) do
    Enum.reduce(gift_card.transactions, 0, fn t, sum -> sum + transaction(t, :amount) end)
  end

  def redeem(gift_card, amount, description) when amount > 0 do
    if current_value(gift_card) - amount < 0 do
      {:error, :insufficient_amount, gift_card}
    else
      {:ok,
       add_transaction(
         gift_card,
         transaction(amount: -amount, description: description, timestamp: DateTime.utc_now())
       )}
    end
  end

  def deposit(gift_card, amount) when amount > 0 do
    {:ok,
     add_transaction(
       gift_card,
       transaction(amount: amount, description: "Insättning", timestamp: DateTime.utc_now())
     )}
  end

  defp add_transaction(gift_card, transaction) do
    %{gift_card | transactions: [transaction | gift_card.transactions]}
    |> up_version()
  end

  defp up_version(gift_card) do
    %{gift_card | version: gift_card.version + 1}
  end
end
