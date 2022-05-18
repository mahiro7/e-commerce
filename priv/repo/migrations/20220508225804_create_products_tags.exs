defmodule Ecommerce.Repo.Migrations.CreateProductsTags do
  use Ecto.Migration

  def change do
    create table(:products_tags) do
      add :tag_id, references(:tags)
      add :product_id, references(:products)
    end

    create unique_index(:products_tags, [:tag_id, :product_id])
  end
end
