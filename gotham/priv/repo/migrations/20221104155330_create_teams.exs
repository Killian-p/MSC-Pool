defmodule Gotham.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :manager_id, references(:users, on_delete: :nothing)
      add :name, :string

      timestamps()
    end

    create index(:teams, [:manager_id])
  end
end
