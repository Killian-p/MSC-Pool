defmodule Gotham.Repo do
  use Ecto.Repo,
    otp_app: :gotham,
    adapter: Ecto.Adapters.Postgres
  
  def init(_type, config) do
    db_url = System.get_env("DATABASE_URL")
    if !is_nil(db_url) do
      {:ok, Keyword.put(config, :url, db_url)}
    else
      {:ok, config}
    end
  end
end
