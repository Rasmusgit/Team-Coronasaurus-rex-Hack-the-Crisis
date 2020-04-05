defmodule CrexWeb.API.BusinessController do
  use CrexWeb, :controller
  action_fallback(CrexWeb.API.FallbackController)

  def index(conn, params) do
    with {:ok, businesses} <- Crex.Businesses.get_all(params) do
      conn
      |> json(%{data: Enum.map(businesses, &render_business/1)})
    end
  end

  def show(conn, %{"id" => business_id}) do
    Crex.Businesses.find(business_id)
    |> case do
      {:ok, business} ->
        conn
        |> json(%{data: render_business(business)})

      :error ->
        conn
        |> not_found()
    end
  end

  defp render_business(business) do
    business
    |> Map.from_struct()
    |> Map.take([:id, :name, :description, :image_url, :type, :city])
    |> Map.put_new(:type, nil)
  end

  defp not_found(conn) do
    conn
    |> put_status(404)
    |> json(%{error: %{code: 404, message: "Not Found"}})
  end
end
