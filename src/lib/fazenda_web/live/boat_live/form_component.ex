defmodule FazendaWeb.BoatLive.FormComponent do
  use FazendaWeb, :live_component

  alias Fazenda.Boats

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage boat records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="boat-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:model]} type="text" label="Model" />
        <.input field={@form[:type]} type="text" label="Type" />
        <.input field={@form[:price]} type="text" label="Price" />
        <.input field={@form[:image]} type="text" label="Image" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Boat</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{boat: boat} = assigns, socket) do
    changeset = Boats.change_boat(boat)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"boat" => boat_params}, socket) do
    changeset =
      socket.assigns.boat
      |> Boats.change_boat(boat_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"boat" => boat_params}, socket) do
    save_boat(socket, socket.assigns.action, boat_params)
  end

  defp save_boat(socket, :edit, boat_params) do
    case Boats.update_boat(socket.assigns.boat, boat_params) do
      {:ok, boat} ->
        notify_parent({:saved, boat})

        {:noreply,
         socket
         |> put_flash(:info, "Boat updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_boat(socket, :new, boat_params) do
    case Boats.create_boat(boat_params) do
      {:ok, boat} ->
        notify_parent({:saved, boat})

        {:noreply,
         socket
         |> put_flash(:info, "Boat created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
