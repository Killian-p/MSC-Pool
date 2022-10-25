defmodule Gothamcity.Repo do
  use Ecto.Repo,
    otp_app: :gothamcity,
    adapter: Ecto.Adapters.Postgres
end
