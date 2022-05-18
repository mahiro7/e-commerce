defmodule EcommerceWeb.ProductLive.FormComponent do
  use EcommerceWeb, :live_component
  use GenServer

  alias Ecommerce.Products
  alias Phoenix.LiveView.JS

  import Logger

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Products.change_product(product)
    categories = Products.list_categories()
    tags = Products.list_tags()
    product_with_tags = product
    |> Ecommerce.Repo.preload(:tags)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:categories, categories)
     |> assign(:changeset, changeset)
     |> assign(:all_tags, tags)
     |> assign(:prod_tags, product_with_tags.tags)
     |> assign(:selected_tags, [])
    }
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    #IO.inspect params

    description = case Map.fetch(socket.assigns, :text_content) do
      {:ok, x} ->
        x
      :error ->
        %{}
    end

    new_product_params = Map.merge(product_params, description)

    changeset =
      socket.assigns.product
      |> Products.change_product(new_product_params)
      |> Map.put(:action, :validate)

    IO.inspect changeset

    assigns = [
      {:changeset, changeset}
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("text-editor", %{"text_content" => %{"ops" => content}} = params, socket) do
    IO.inspect "Entrou aqui #{content |> Jason.encode!}"
    text = case content |> Jason.encode! do
      "[{\"insert\":\"\\n\"}]" ->
        ""
      x ->
        x
    end
    {:noreply, push_event(socket, "set-input-value", %{value: text}) }
  end

  def create_category(value) do
    case Products.create_category(%{name: value}) do
      {:ok, %{id: id}} ->
        "#{id}"
      {:error, _} ->
        "1" ##Tratamento futuro
    end
  end

  def handle_event("change_tags", tags, socket) do
    {:noreply, assign(socket, :selected_tags, tags)}
  end

  defp handle_tags(tags) do
    tags
    |> Enum.map(&(
      case Integer.parse(&1) do
        {x, ""} ->
          Products.get_tag!(x)
        _ ->
          %{name: &1}
      end
    ))
    |> IO.inspect
  end

  def handle_event("save", %{"product" => %{"category_id" => category_id} = product_params} = params, socket) do
    tags = socket.assigns.selected_tags
    |> handle_tags()
    if (Integer.parse(category_id) == :error) do
      final_params = %{product_params
        | "category_id" => create_category(category_id)
      }
      save_product(socket, socket.assigns.action, final_params, tags)
    else
      save_product(socket, socket.assigns.action, product_params, tags)
    end
  end

  defp save_product(socket, :edit, product_params, tags) do
    case Products.update_product(socket.assigns.product, product_params, tags) do
      {:ok, _product} ->
        IO.puts "deu erro  não poh"
        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts "deu erro poh"
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_product(socket, :new, product_params, tags) do
    case Products.create_product(product_params, tags) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
