defmodule Farmcontrol.Repo do
  use Ecto.Repo,
    otp_app: :farmcontrol,
    adapter: Ecto.Adapters.Postgres
end
