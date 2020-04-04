defmodule CrexWeb.API.SessionController do
  use CrexWeb, :controller
  action_fallback CrexWeb.API.FallbackController

  defmodule Login do
    use ParamSchema

    embedded_schema do
      field :email, :string
      field :password, :string
    end

    def validate(changeset) do
      changeset
      |> validate_required([:email, :password])
    end
  end

  def create(conn, params) do
    with {:ok, login} <- Login.create(params),
    {:authenticate, {:ok, user}} <- {:authenticate, Crex.Users.authenticate(login.email, login.password)} do

      access_token = Crex.AccessToken.create(user.id)
      conn
      |> put_resp_cookie("access_token", access_token, http_only: true, path: "/api")
      |> json(%{access_token: access_token})
    else
      {:authenticate, _} ->
        conn
        |> put_status(422)
        |> text("")
    end
  end

  def show(conn, _params) do
    user = conn.assigns.current_user

    conn
    |> json(%{data: %{
      user_id: user.id,
      email: user.email,
      profileImage: Gravatar.gravatar_url(user.email)
    }})
  end
end
