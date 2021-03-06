# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ecommerce.Repo.insert!(%Ecommerce.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Ecommerce.Products.Category
alias Ecommerce.Repo

category = ~w(Moletom Camiseta)

Enum.each(category, fn name ->
  Repo.insert!(%Category{name: name})
end)
