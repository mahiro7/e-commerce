defmodule Ecommerce.Repo.Migrations.ChangeStatusTypeOnProductsTable do
  use Ecto.Migration

  def change do
    alter table("products") do
      remove :status
    end

    alter table("products") do
      add :status, :boolean
    end
  end
end
