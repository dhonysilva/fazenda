defmodule Fazenda.Repo do
  use Ecto.Repo,
    otp_app: :fazenda,
    adapter: Ecto.Adapters.Postgres
end
