defmodule CrexWeb.Router do
  use CrexWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :protected_api do
    plug(:accepts, ["json"])
    plug(CrexWeb.Plugs.AuthAPI)
  end

  scope "/", CrexWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/login", PageController, :login)
  end

  scope "/api", CrexWeb.API do
    pipe_through(:api)
    resources("/businesses", BusinessController, only: [:index, :show])
    post("/session", SessionController, :create)
    post("/signup", CommandController, :execute, assigns: %{command: Crex.Actions.Signup})
  end

  scope "/api", CrexWeb.API do
    pipe_through(:protected_api)
    resources("/gift_cards", GiftCardController)
    get("/session", SessionController, :show)
    post("/:command", CommandController, :execute)
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through([:browser])

      forward("/mailbox", Plug.Swoosh.MailboxPreview, base_path: "/dev/mailbox")
      resources("/db", CrexWeb.DBController)
    end
  end
end
