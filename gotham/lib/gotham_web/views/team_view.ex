defmodule GothamWeb.TeamView do
  use GothamWeb, :view
  alias GothamWeb.TeamView
  alias GothamWeb.UserView

  def render("index.json", %{teams: teams}) do
    %{data: render_many(teams, TeamView, "team.json")}
  end

  def render("show.json", %{team: team}) do
    %{data: render_one(team, TeamView, "team.json")}
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
end
