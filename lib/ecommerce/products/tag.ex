defmodule Ecommerce.Products.Tag do
  use Ecto.Schema
  alias Ecommerce.Products.Product
  import Ecto.Changeset

  schema "tags" do
    field :name, :string
    many_to_many :products, Product, [join_through: "products_tags"]
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
