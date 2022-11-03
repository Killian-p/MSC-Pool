defmodule Gotham.Repo.Migrations.AddUserPasswordRole do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password, :string
      add :roles, :string, default: "EMPLOYEE", null: false
    end
  end
end
