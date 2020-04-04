# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Crex.Repo.insert!(%Crex.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Crex.Repo.insert!(%Crex.DB.Business{name: "Idas Storkök", city: "MALMÖ"})
Crex.Repo.insert!(%Crex.DB.Business{name: "Chillout Sushi", city: "MALMÖ"})
Crex.Repo.insert!(%Crex.DB.Business{name: "Charlies Burgers", city: "MALMÖ"})
Crex.Repo.insert!(%Crex.DB.Business{name: "Kvartersblomman", city: "MALMÖ"})

for i <- 0..100 do
  Crex.Repo.insert!(%Crex.DB.User{
    email: Faker.Internet.email(),
    display_name: Faker.Name.name()
  })
end
