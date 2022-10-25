defmodule Gothamcityhall.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :firstname, :string
      add :email, :string

      timestamps()
    end
  end
end
