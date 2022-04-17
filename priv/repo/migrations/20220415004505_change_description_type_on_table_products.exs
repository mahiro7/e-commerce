defmodule Ecommerce.Repo.Migrations.ChangeDescriptionTypeOnTableProducts do
  use Ecto.Migration

  def change do
    alter table("products") do
      remove :description
    end

    alter table("products") do
      add :description, :map
    end
  end
end
