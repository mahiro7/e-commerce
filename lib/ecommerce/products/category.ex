defmodule Ecommerce.Products.Category do
  use Ecto.Schema
  alias Ecommerce.Products.Product
  import Ecto.Changeset

  schema "categories" do
    field :name, :string
    has_many :products, Product
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
