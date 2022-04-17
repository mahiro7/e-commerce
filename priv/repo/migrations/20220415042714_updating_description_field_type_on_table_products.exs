defmodule Ecommerce.Repo.Migrations.UpdatingDescriptionFieldTypeOnTableProducts do
  use Ecto.Migration

  def change do
    alterable("products") do
      remove :description
    end
    alter table("products") do
      add :description, :map, default: %{}
    end
  end
end
