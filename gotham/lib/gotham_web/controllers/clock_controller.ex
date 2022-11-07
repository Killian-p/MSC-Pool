defmodule GothamWeb.ClockController do
  use GothamWeb, :controller

  alias Gotham.Workingtimes
  alias Gotham.Clocks
  alias Gotham.Clocks.Clock
  alias Gotham.Users

  action_fallback GothamWeb.FallbackController

  def index(conn, _params) do
    clocks = Clocks.list_clocks()
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- Clocks.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
      |> render("show.json", clock: clock)
    end
  end

  def show(conn, %{"userID" => userId}) do
    token = get_req_header(conn, "token")

    cond do
      GothamWeb.Token.is_token_valid(List.first(token), ["ADMIN", "MANAGER", "EMPLOYEE"]) ->
        user = Users.get_user!(userId, [:clocks])
        render(conn, "show.json", clock: user.clocks)
      true ->
        put_status(conn, :unauthorized) |> json(%{message: "You're not authorized to perform this action"})
    end
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Clocks.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Clocks.update_clock(clock, clock_params) do
      render(conn, "show.json", clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Clocks.get_clock!(id)

    with {:ok, %Clock{}} <- Clocks.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end

  def add_user_clock(conn, %{"clock" => clock_params, "userID" => userId}) do
    token = get_req_header(conn, "token")

    cond do
      GothamWeb.Token.is_token_valid(List.first(token), ["ADMIN", "MANAGER", "EMPLOYEE"]) ->
        cond do
          Clocks.user_has_clock(userId) ->
            clock = Clocks.get_clock!(userId)
            data = %{start: clock.time, end: Map.get(clock_params, "time"), user_id: userId}
            with {:ok, %Clock{} = clock} <- Clocks.update_clock(clock, Map.put(clock_params, "status", !clock.status)) do
              cond do
                !clock.status ->
                  IO.inspect "set to false"
                  Workingtimes.create_workingtime(data)
                true ->
                  IO.inspect "set to true"
              end
              render(conn, "show.json", clock: clock)
            end
          true ->
            with {:ok, %Clock{} = clock} <- Clocks.create_clock(Map.put(clock_params, "user_id", userId)) do
              render(conn, "show.json", clock: clock)
            end
        end
      true ->
        put_status(conn, :unauthorized) |> json(%{message: "You're not authorized to perform this action"})
    end
  end
end
