defmodule Ecommerce.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :title, :string
      add :description, :text
      add :status, :binary
      add :price, :float
      add :promo_price, :float

      timestamps()
    end
  end
end
