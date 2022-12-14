defmodule Gotham.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  alias Gotham.Workingtimes

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string

      timestamps()
    end
  end
end
