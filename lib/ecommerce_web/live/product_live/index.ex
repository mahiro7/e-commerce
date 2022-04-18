defmodule EcommerceWeb.ProductLive.Index do
  use EcommerceWeb, :live_view

  import Logger

  alias Ecommerce.Products
  alias Ecommerce.Products.Product

  alias Phoenix.LiveView.JS

  


  @impl true
  def mount(_params, _session, socket) do
    assigns = 
      [
        {:products, list_products()},
        {:filter, :nil},
        {:search, ""}
      ]
      
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Products.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Adicionar produto")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Products.get_product!(id)
    {:ok, _} = Products.delete_product(product)

    {:noreply, assign(socket, :products, list_products())}
  end

  defp list_products do
    Products.list_products()
  end

  def select_option() do
    JS.remove_class("selected", to: ".nav-option")
    |> JS.add_class("selected")
    |> JS.push("filter")
  end
  def handle_event("filter", %{"filter" => filter}, socket) do
    Logger.info("Filter changed to #{filter}")
    {:noreply, assign(socket, :filter, String.to_atom(filter))}
  end

  def handle_event("search", %{"search" => search}, socket) do
    Logger.info("searching: #{search}")
    {:noreply, assign(socket, :search, search)}
  end

  def select_option() do
    JS.remove_class("selected", to: ".nav-option")
    |> JS.add_class("selected")
    |> JS.push("filter")
  end

end
