defmodule FarmcontrolWeb.LightLive do
    use FarmcontrolWeb, :live_view

    def mount(_params, _session, socket) do
        socket = assign(socket, brightness: 10)
        {:ok, socket}
    end

    def render(assigns) do
        ~H"""
        <h1>Front Porch Light</h1>
        <div id="light">
            <div class="meter">
                <span style={"width: #{@brightness}%"}>
                    <%= @brightness %>%
                </span>
            </div>

            <button phx-click="off">Off</button>
            <button phx-click="on">On</button>
        </div>
        """
    end

    def handle_event("on", _, socket) do
        socket = assign(socket, brightness: 100)
        {:noreply, socket}
    end

    def handle_event("off", _, socket) do
        socket = assign(socket, brightness: 0)
        {:noreply, socket}
    end


end