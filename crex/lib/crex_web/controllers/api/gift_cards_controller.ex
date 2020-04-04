defmodule CrexWeb.API.GiftCardController do
  use CrexWeb, :controller
  action_fallback CrexWeb.API.FallbackController

  def index(conn, params) do
    {:ok, cards} = Crex.Storage.get_cards_for_user(conn.assigns.current_user.id)

    conn
    |> json(%{data: Enum.map(cards, &render_card/1)})
  end

  defp render_card(card) do
    business = Crex.Businesses.get(card.business)

    %{
      id: card.identifier,
      value: Crex.GiftCard.current_value(card),
      business: %{
        id: business.id,
        name: business.name
      }
    }
  end
end
