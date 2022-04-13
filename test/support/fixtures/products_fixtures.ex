defmodule Ecommerce.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ecommerce.Products` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        price: 120.5,
        promo_price: 120.5,
        status: "some status",
        title: "some title"
      })
      |> Ecommerce.Products.create_product()

    product
  end
end
