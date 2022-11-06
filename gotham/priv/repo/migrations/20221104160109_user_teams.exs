defmodule Gotham.Repo.Migrations.UserTeams do
  use Ecto.Migration

  def change do
    create table(:user_team) do
      add(:team_id, references(:teams, on_delete: :delete_all))
      add(:user_id, references(:users, on_delete: :delete_all))
    end

    create(index(:user_team, [:team_id]))
    create(index(:user_team, [:user_id]))
  end
end
