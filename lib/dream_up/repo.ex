defmodule DreamUp.Repo do
  use Ecto.Repo,
    otp_app: :dream_up,
    adapter: Ecto.Adapters.Postgres
end
