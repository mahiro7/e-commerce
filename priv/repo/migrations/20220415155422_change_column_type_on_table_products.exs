defmodule Ecommerce.Repo.Migrations.ChangeColumnTypeOnTableProducts do
  use Ecto.Migration

  def change do
    alter table("products") do
      remove :description
    end
    alter table("products") do
      add :description, :string
    end
  end
end
