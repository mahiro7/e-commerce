defmodule Ecommerce.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :price, :float
    field :promo_price, :float
    field :status, :binary
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :description, :status, :price, :promo_price])
    |> validate_required([:title, :description, :status, :price, :promo_price])
  end
end