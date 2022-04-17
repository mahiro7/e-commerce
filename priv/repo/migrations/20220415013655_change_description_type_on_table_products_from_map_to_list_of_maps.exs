defmodule Ecommerce.Repo.Migrations.ChangeDescriptionTypeOnTableProductsFromMapToListOfMaps do
  use Ecto.Migration

  def change do
    alter table("products") do
      remove :description
    end
    alter table("products") do
      add :description, {:array, :map}
    end
  end
end
