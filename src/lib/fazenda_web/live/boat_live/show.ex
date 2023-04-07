defmodule FazendaWeb.BoatLive.Show do
  use FazendaWeb, :live_view

  alias Fazenda.Boats

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:boat, Boats.get_boat!(id))}
  end

  defp page_title(:show), do: "Show Boat"
  defp page_title(:edit), do: "Edit Boat"
end
