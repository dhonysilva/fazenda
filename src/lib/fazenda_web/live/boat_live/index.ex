defmodule FazendaWeb.BoatLive.Index do
  use FazendaWeb, :live_view

  alias Fazenda.Boats
  alias Fazenda.Boats.Boat

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :boats, Boats.list_boats())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Boat")
    |> assign(:boat, Boats.get_boat!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Boat")
    |> assign(:boat, %Boat{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Boats")
    |> assign(:boat, nil)
  end

  @impl true
  def handle_info({FazendaWeb.BoatLive.FormComponent, {:saved, boat}}, socket) do
    {:noreply, stream_insert(socket, :boats, boat)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    boat = Boats.get_boat!(id)
    {:ok, _} = Boats.delete_boat(boat)

    {:noreply, stream_delete(socket, :boats, boat)}
  end
end
