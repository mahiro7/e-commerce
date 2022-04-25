defmodule EcommerceWeb.ProductLive.Index do
  use EcommerceWeb, :live_view
  use GenServer

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
        {:search, ""},
        {:checked_items, []},
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
    assigns = [
      {:filter, String.to_atom(filter)},
      {:checked_items, []}
    ]
    GenServer.cast(self(), {"set_indeterminate", []})
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("search", %{"search" => search}, socket) do
    Logger.info("searching: #{search}")
    {:noreply, assign(socket, :search, search)}
  end

  def handle_event("check_all", params, socket) do
    IO.inspect socket.assigns.checked_items
    checked_items = case params do
      %{"value" => "on"} ->
        check_all(socket)
      %{"_target" => ["check-all"], "check-all" => "on"} ->
        check_all(socket)
      %{} ->
        []
    end

    assigns = [
      {:checked_items, checked_items},
      {:all_checked, (if (checked_items != []), do: true, else: false)}
    ]

    {:noreply, assign(socket, assigns)}
  end

  defp check_all(socket) do
    products = socket.assigns.products

    case socket.assigns.filter do
      :nil ->
        Enum.map(products, &(&1.id))
      :true ->
        Enum.flat_map(products, &(if &1.status == true, do: [&1.id], else: []))
      :false ->
        Enum.flat_map(products, &(if &1.status == false, do: [&1.id], else: []))
    end
  end

  def handle_event("checked_item", params, socket) do
    checked_items = case params do
      %{"id" => x, "value" => "on"} ->
        socket.assigns.checked_items ++ [String.to_integer(x)]
      %{"id" => x} ->
        socket.assigns.checked_items -- [String.to_integer(x)]
    end

    IO.inspect socket.assigns.products

    GenServer.cast(self(), {"set_indeterminate", checked_items})

    {:noreply, assign(socket, :checked_items, checked_items)}
  end

  def handle_cast({"set_indeterminate", checked_items}, socket) do
    products = socket.assigns.products
    value = %{value: %{
      checked_items: checked_items,
      all_items: Enum.count(products),
      active_ids: get_active_ids(products),
      sketch_ids: get_sketch_ids(products),
      filter: socket.assigns.filter
    }}

    {:noreply, push_event(socket, "set-indeterminate", value)}
  end

  defp get_active_ids(products) do
    products
    |> Enum.flat_map(fn %{id: id, status: status} ->
      (if status == :true, do: [id], else: [])
    end)
  end
  defp get_sketch_ids(products) do
    products
    |> Enum.flat_map(fn %{id: id, status: status} ->
      (if status == :false, do: [id], else: [])
    end)

  end


  def handle_event("redirect_to_index", _, socket) do
    {:noreply, push_redirect(socket, to: "/products")}
  end

  def handle_event("test", a, socket) do
    IO.inspect a
    {:noreply, socket}
  end

end
