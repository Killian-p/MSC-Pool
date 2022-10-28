defmodule GothamWeb.ClockController do
  use GothamWeb, :controller

  alias Gotham.Workingtimes
  alias Gotham.Clocks
  alias Gotham.Clocks.Clock

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

  def show(conn, %{"id" => id}) do
    clock = Clocks.get_clock!(id)
    render(conn, "show.json", clock: clock)
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
    cond do
      Clocks.user_has_clock(userId) ->
        clock = Clocks.get_clock!(userId)
        IO.inspect clock.time
        IO.inspect Map.get(clock_params, "time")
        data = %{start: clock.time, end: Map.get(clock_params, "time"), user: userId}
        with {:ok, %Clock{} = clock} <- Clocks.update_clock(clock, Map.put(clock_params, "status", !clock.status)) do
          IO.inspect clock.status
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
        with {:ok, %Clock{} = clock} <- Clocks.create_clock(Map.put(clock_params, "user", userId)) do
          render(conn, "show.json", clock: clock)
        end
    end
    # if nil do post

    # if not nil do update



    # with {:ok, %Clock{} = clock} <- Clocks.create_clock(Map.put(clock_params, "user", userId)) do
    #   conn
    #   |> put_status(:created)
    #   # |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
    #   |> render("show.json", clock: clock)
    # end
  end
end
