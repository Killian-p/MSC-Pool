defmodule Gotham.Teams do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query, warn: false
  alias Gotham.Repo

  alias Gotham.Teams
  alias Gotham.Teams.Team
  alias Gotham.Users
  alias Gotham.Users.User

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams(preloads \\ []) do
    Repo.all(Team)
    |> Repo.preload(preloads)
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id, preloads \\ []) do
   Repo.get!(Team, id)
   |> Repo.preload(preloads)
  end

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  def upsert_team_user(team, userId) do
    users =
      User
      |> where([user], user.id == ^userId)
      |> Repo.all()
      |> Repo.preload(:teams)
    
    # IO.inspect users

    # IO.inspect team.users

    IO.inspect team.users ++ users

    with {:ok, _struct} <-
      team
      |> Repo.preload(:users)
      |> Team.changeset_add_user_team(team.users ++ users)
      |> Repo.update() do
      {:ok, Teams.get_team!(team.id)}
    else
      error ->
        error
    end
  end

  def get_user_of_team(teamId) do
    query = from(user in "users",
      inner_join: user_team in "user_team",
      on: user.id == user_team.user_id,
      where: user_team.team_id == ^String.to_integer(teamId),
      select: [:email, :id, :username, :roles])
    Repo.all(query)
  end

  def get_manager_team(managerId) do
    Repo.all(from team in Team, where: team.manager_id == ^String.to_integer(managerId))
    |> Repo.preload([:users, users: :workingtimes]) 
  end
end
