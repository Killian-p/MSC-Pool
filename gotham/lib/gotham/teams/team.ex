defmodule Gotham.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  alias Gotham.Users.User
  alias Gotham.Teams.Team

  schema "teams" do

    field :manager_id, :id
    field :name, :string
    many_to_many(:users, User, join_through: "user_team", on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:manager_id, :name])
    |> validate_required([:manager_id, :name])
  end

  def changeset_add_user_team(%Team{} = team, user) do
    team
    |> cast(%{}, [:manager_id, :name])
    # associate user to the team
    |> put_assoc(:users, user)
  end
end
