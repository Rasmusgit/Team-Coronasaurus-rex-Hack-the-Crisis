defmodule Crex.Seed do
  alias Crex.Business

  @business [
    %Business{
      id: "YGBQ6W45VAUZKG4IPHXZGRIQP6WHKIBO",
      name: "Idas Storkök",
      city: "MALMÖ",
      type: "Local Cousine"
    },
    %Business{
      id: "CUYAVUXYPHYWEENMOHYSDBM5TZPPX7QO",
      name: "Chillout Sushi",
      city: "MALMÖ",
      type: "Sushi"
    },
    %Business{
      id: "T6JQH4DVRFDXMPRIDVTPO52IOCZHXVPU",
      name: "Charlies Burgers",
      city: "MALMÖ",
      type: "Burgers"
    }
  ]

  @users [
    Crex.User.create!(
      email: "kwando@merciless.me",
      password: "1234",
      id: "JP53S3NB64C7YC64WLNYXWQVF66PVAMX",
      registered_at: DateTime.utc_now()
    ),
    Crex.User.create!(
      email: "nisse@manpower.se",
      password: "1234",
      id: "QYI3V32LRAOC3ARU2DFV3TT4SCA2SPJN",
      registered_at: DateTime.utc_now()
    ),
    Crex.User.create!(
      email: "lotta@merciless.me",
      password: "1234",
      id: "W7LXATWPQGINVOHRN7JGGU64WCAAHE4B",
      registered_at: DateTime.utc_now()
    ),
    Crex.User.create!(
      email: "conny@merciless.me",
      password: "1234",
      id: "3Y2K4NG2IHGQYRNZFDV557RFXAIJ3FPA",
      registered_at: DateTime.utc_now()
    )
  ]

  def run() do
    CubDB.put_multi(
      Crex.Storage,
      Enum.map(@business, fn b ->
        {Crex.Storage.storage_key(b), b}
      end)
    )

    for user <- @users do
      Crex.Users.store(user)
    end
  end
end
