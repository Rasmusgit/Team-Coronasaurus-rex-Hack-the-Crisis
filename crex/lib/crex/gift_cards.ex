defmodule Crex.GiftCards do
  def find(card_code) do
    Crex.Storage.fetch({:gift_card, card_code})
  end
end
