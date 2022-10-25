defmodule Gothamcityhall.Repo do
  use Ecto.Repo,
    otp_app: :gothamcityhall,
    adapter: Ecto.Adapters.Postgres
end
