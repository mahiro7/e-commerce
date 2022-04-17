defmodule EcommerceWeb.ProductLive.RichTextFormComponent do
  use EcommerceWeb, :live_component

  import Logger

  def render(assigns) do
    Logger.info("Entrou")
    

    ~H"""
    <div></div>
    """ 

  end

  def handle_event("validate_form", %{"richtext_form" => params}, socket) do
    {:noreply, socket}
  end

def handle_event(
  "handle_clientside_richtext", 
  %{"richtext_data" => richtext_data},
  socket) do 
  {:noreply, 
    socket }
    end
end
