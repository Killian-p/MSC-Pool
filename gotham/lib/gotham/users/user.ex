defmodule Gotham.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Gotham.Teams.Team
  alias Gotham.Workingtimes.Workingtime
  alias Gotham.Clocks.Clock

  schema "users" do
    field :email, :string
    field :username, :string
    field :roles, :string, default: "EMPLOYEE"
    field :password, :string
    many_to_many(:teams, Team, join_through: "user_team", on_replace: :delete)
    has_many(:workingtimes, Workingtime)
    has_one(:clocks, Clock)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:username, :email, :password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
  end

  def changeset_user_roles(user, attrs) do
    user
    |> cast(attrs, [:roles])
    |> validate_required([:roles])
    # |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
  end
end
