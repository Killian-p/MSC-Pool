defmodule GothamWeb.TeamController do
  use GothamWeb, :controller

  alias Gotham.Teams
  alias Gotham.Teams.Team
  alias Gotham.Users
  alias Gotham.Users.User
  import Ecto.Query
  alias Gotham.Repo

  action_fallback GothamWeb.FallbackController

  def index(conn, _params) do
    token = get_req_header(conn, "token")

    cond do
      GothamWeb.Token.is_token_valid(List.first(token), ["ADMIN"]) ->
        teams = Teams.list_teams([:users, users: :workingtimes])
        render(conn, "list.json", teams: teams)
      true ->
        put_status(conn, :unauthorized) |> json(%{message: "You're not authorized to perform this action"})
    end
  end

  def create(conn, %{"team" => team_params}) do
    token = get_req_header(conn, "token")

    cond do
      GothamWeb.Token.is_token_valid(List.first(token), ["ADMIN", "MANAGER"]) ->
        manager = Users.get_user!(team_params["manager_id"])
        cond do
          manager.roles != "EMPLOYEE" ->
            with {:ok, %Team{} = team} <- Teams.create_team(team_params) do
              conn
              |> put_status(:created)
              |> render("show.json", team: team)
            end
          true ->
            put_status(conn, :bad_request) |> json(%{message: "Employee cannot manage teams"})
        end
      true ->
        put_status(conn, :unauthorized) |> json(%{message: "You're not authorized to perform this action"})
    end
  end

  def show(conn, %{"teamID" => id}) do
    token = get_req_header(conn, "token")

    team = Teams.get_team!(id)
    cond do
      GothamWeb.Token.is_token_valid(List.first(token), ["ADMIN"]) ->
        render(conn, "show.json", team: team)
      true ->
        with {:ok, claims} <- GothamWeb.Token.get_token_data(List.first(token)) do
          cond do
            GothamWeb.Token.is_token_valid(List.first(token), ["MANAGER"]) && claims["user_id"] == team.manager_id ->
              render(conn, "show.json", team: team)
            true ->
              put_status(conn, :unauthorized) |> json(%{message: "You're not authorized to perform this action"})
          end
        end
    end
  end

  def update(conn, %{"teamID" => id, "team" => team_params}) do
    token = get_req_header(conn, "token")
    team = Teams.get_team!(id)

    cond do
      GothamWeb.Token.is_token_valid(List.first(token), ["ADMIN"]) ->
        cond do
          Map.has_key?(team_params, "manager_id") ->
            manager = Users.get_user!(team_params["manager_id"])
            cond do
              manager.roles != "EMPLOYEE" ->
                with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
                  render(conn, "show.json", team: team)
                end
              true ->
                put_status(conn, :bad_request) |> json(%{message: "Employee cannot manage teams"})
            end
          true ->
            with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
              render(conn, "show.json", team: team)
            end
        end
      true ->
        with {:ok, claims} <- GothamWeb.Token.get_token_data(List.first(token)) do
          cond do
            GothamWeb.Token.is_token_valid(List.first(token), ["MANAGER"]) && claims["user_id"] == team.manager_id ->
              cond do
                Map.has_key?(team_params, "manager_id") ->
                  manager = Users.get_user!(team_params["manager_id"])
                  cond do
                    manager.roles != "EMPLOYEE" ->
                      with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
                        render(conn, "show.json", team: team)
                      end
                    true ->
                      put_status(conn, :bad_request) |> json(%{message: "Employee cannot manage teams"})
                  end
                true ->
                  with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
                    render(conn, "show.json", team: team)
                  end
              end
            true ->
              put_status(conn, :unauthorized) |> json(%{message: "You're not authorized to perform this action"})
          end
        end
    end
  end

  def delete(conn, %{"teamID" => id}) do
    token = get_req_header(conn, "token")
    team = Teams.get_team!(id)

    cond do
      GothamWeb.Token.is_token_valid(List.first(token), ["ADMIN"]) ->
        with {:ok, %Team{}} <- Teams.delete_team(team) do
          send_resp(conn, :no_content, "")
        end
      true ->
        with {:ok, claims} <- GothamWeb.Token.get_token_data(List.first(token)) do
          cond do
            GothamWeb.Token.is_token_valid(List.first(token), ["MANAGER"]) && claims["user_id"] == team.manager_id ->
              with {:ok, %Team{}} <- Teams.delete_team(team) do
                send_resp(conn, :no_content, "")
              end
            true ->
              put_status(conn, :unauthorized) |> json(%{message: "You're not authorized to perform this action"})
          end
        end
    end
  end

  def add_user_to_team(conn, %{"teamID" => teamId, "userID" => userId}) do
    token = get_req_header(conn, "token")
    team = Teams.get_team!(teamId, [:users])

    cond do
      GothamWeb.Token.is_token_valid(List.first(token), ["ADMIN"]) ->
        with {:ok, %Team{}} <- Teams.upsert_team_user(team, userId) do
          send_resp(conn, :no_content, "")
        end
      true ->
        with {:ok, claims} <- GothamWeb.Token.get_token_data(List.first(token)) do
          cond do
            GothamWeb.Token.is_token_valid(List.first(token), ["MANAGER"]) && claims["user_id"] == team.manager_id ->
              with {:ok, %Team{}} <- Teams.upsert_team_user(team, userId) do
                send_resp(conn, :no_content, "")
              end
            true ->
              put_status(conn, :unauthorized) |> json(%{message: "You're not authorized to perform this action"})
          end
        end
    end
  end

  def delete_user_team(conn, %{"teamID" => teamId, "userID" => userId}) do
    token = get_req_header(conn, "token")
    team = Teams.get_team!(teamId, [:users])
    user = Users.get_user!(userId)

    cond do
      GothamWeb.Token.is_token_valid(List.first(token), ["ADMIN"]) ->
        with {:ok, %Team{}} <- Teams.delete_team_user(team, user) do
          send_resp(conn, :no_content, "")
        end
      true ->
        with {:ok, claims} <- GothamWeb.Token.get_token_data(List.first(token)) do
          cond do
            GothamWeb.Token.is_token_valid(List.first(token), ["MANAGER"]) && claims["user_id"] == team.manager_id ->
              with {:ok, %Team{}} <- Teams.delete_team_user(team, user) do
                send_resp(conn, :no_content, "")
              end
            true ->
              put_status(conn, :unauthorized) |> json(%{message: "You're not authorized to perform this action"})
          end
        end
    end
  end

  def list_users_of_team(conn, %{"teamID" => teamId}) do
    token = get_req_header(conn, "token")
    team = Teams.get_team!(teamId, [:users])
    # render(conn, "team_users.json", users: team.users)

    cond do
      GothamWeb.Token.is_token_valid(List.first(token), ["ADMIN"]) ->
        render(conn, "team_users.json", users: team.users)
      true ->
        with {:ok, claims} <- GothamWeb.Token.get_token_data(List.first(token)) do
          cond do
            GothamWeb.Token.is_token_valid(List.first(token), ["MANAGER"]) && claims["user_id"] == team.manager_id ->
              render(conn, "team_users.json", users: team.users)
            true ->
              put_status(conn, :unauthorized) |> json(%{message: "You're not authorized to perform this action"})
          end
        end
    end
  end

  def get_team_of_manager(conn, %{"userID" => managerId}) do
    token = get_req_header(conn, "token")

    cond do
      GothamWeb.Token.is_token_valid(List.first(token), ["ADMIN", "MANAGER"]) ->
        manager_teams = Teams.get_manager_team(managerId)
        render(conn, "list.json", teams: manager_teams)
      true ->
        put_status(conn, :unauthorized) |> json(%{message: "You're not authorized to perform this action"})
    end
  end

  defp get_nested_list(list) do
    cond do
      List.first(list) ->
        user = List.first(list)
        user.workingtimes ++ get_nested_list(List.delete_at(list, 0))
      true ->
        []
    end
  end

  def get_workingtimes_of_team(conn, %{"teamID" => teamId}) do
    token = get_req_header(conn, "token")

    cond do
      GothamWeb.Token.is_token_valid(List.first(token), ["ADMIN", "MANAGER"]) ->
        team = Teams.get_team!(teamId, [:users, users: :workingtimes])
        list = get_nested_list(team.users)
        render(conn, "team_workingtimes.json", workingtimes: list)
      true ->
        put_status(conn, :unauthorized) |> json(%{message: "You're not authorized to perform this action"})
    end
  end
end