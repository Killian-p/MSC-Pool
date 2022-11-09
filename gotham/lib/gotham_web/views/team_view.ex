defmodule GothamWeb.TeamView do
  use GothamWeb, :view
  alias GothamWeb.TeamView
  alias GothamWeb.UserView
  alias GothamWeb.WorkingtimeView

  def render("index.json", %{teams: teams}) do
    %{data: render_many(teams, TeamView, "team.json")}
  end

  def render("show.json", %{team: team}) do
    %{data: render_one(team, TeamView, "team.json")}
  end

  def render("list.json", %{teams: teams}) do
    IO.inspect teams
    %{data: render_many(teams, TeamView, "team_and_user.json")}
  end

  def render("team_and_user.json", %{team: team}) do
    IO.inspect team
    %{
      id: team.id,
      manager_id: team.manager_id,
      name: team.name,
      users: render_many(team.users, UserView, "user_with_workingtime.json" )
    }
  end

  def render("team.json", %{team: team}) do
    %{
      id: team.id,
      manager_id: team.manager_id,
      name: team.name
    }
  end

  def render("team_users.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("team_workingtimes.json", %{workingtimes: workingtimes}) do
    IO.inspect workingtimes
    %{data: render_many(workingtimes, WorkingtimeView, "workingtime.json")}
  end
end
