defmodule Ecommerce.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias Ecommerce.Repo

  alias Ecommerce.Products.{Product, Category, Tag}

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products(params \\ %{}) do
    from(
      p in Product,
      order_by: ^filter_order_by(params["order_by"])
    )
    |> Repo.all()
    |> Repo.preload([:category, :tags])
  end

  defp filter_order_by("title_asc"), do: [asc: :title]
  defp filter_order_by("title_desc"), do: [desc: :title]

  defp filter_order_by("status_asc"), do: [asc: :status]
  defp filter_order_by("status_desc"), do: [desc: :status]

  defp filter_order_by("category_asc"), do: [asc: :category]
  defp filter_order_by("category_desc"), do: [desc: :category]

  defp filter_order_by(_), do: [asc: :id]

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id) do
    Repo.get!(Product, id)
    |> Repo.preload(:tags)
  end

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Repo.preload([:category, :tags])
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def create_product(attrs, tags) do
    %Product{}
    |> Repo.preload([:category, :tags])
    |> Product.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tags, tags)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Repo.preload([:category, :tags])
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  def update_product(%Product{} = product, attrs, tags) do
    product
    |> Repo.preload([:category, :tags])
    |> Product.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tags, tags)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    product
    |> Repo.preload([:category, :tags])
    |> Product.changeset(attrs)
  end

  def delete_list_of_products(ids) do
    query = from p in Product,
            where: p.id in ^ids
    Repo.delete_all(query)
  end

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def list_categories do
    Repo.all(Category)
  end

  def get_tag!(id) do
    Repo.get!(Tag, id)
  end
  def list_tags do
    Repo.all(Tag)
  end
end
