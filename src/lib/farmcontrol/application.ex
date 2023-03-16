defmodule Farmcontrol.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FarmcontrolWeb.Telemetry,
      # Start the Ecto repository
      Farmcontrol.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Farmcontrol.PubSub},
      # Start Finch
      {Finch, name: Farmcontrol.Finch},
      # Start the Endpoint (http/https)
      FarmcontrolWeb.Endpoint
      # Start a worker by calling: Farmcontrol.Worker.start_link(arg)
      # {Farmcontrol.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Farmcontrol.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FarmcontrolWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
