defmodule EcommerceWeb.ProductLive.FormComponent do
  use EcommerceWeb, :live_component

  alias Ecommerce.Products
  alias Phoenix.LiveView.JS

  import Logger

  @impl true
  def update(%{product: product} = assigns, socket) do
    Logger.info(assigns)
    changeset = Products.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
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
    #change = %{"description" => content |> Jason.encode!}

    text = case content |> Jason.encode! do
      "[{\"insert\":\"\\n\"}]" ->
        ""
      x ->
        x
    end


    {:noreply, push_event(socket, "set-input-value", %{value: text}) }
                #|> assign(:text_content, change)}
  end

  

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  defp save_product(socket, :edit, product_params) do
    case Products.update_product(socket.assigns.product, product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_product(socket, :new, product_params) do
    case Products.create_product(product_params) do
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
