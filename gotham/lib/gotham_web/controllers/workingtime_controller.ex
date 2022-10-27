defmodule GothamWeb.WorkingtimeController do
  use GothamWeb, :controller

  alias Gotham.Workingtimes
  alias Gotham.Workingtimes.Workingtime

  action_fallback GothamWeb.FallbackController

  def index(conn, _params) do
    workingtimes = Workingtimes.list_workingtimes()
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def create(conn, %{"workingtime" => workingtime_params}) do
    with {:ok, %Workingtime{} = workingtime} <- Workingtimes.create_workingtime(workingtime_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.workingtime_path(conn, :show, workingtime))
      |> render("show.json", workingtime: workingtime)
    end
  end

  def show(conn, %{"id" => id}) do
    workingtime = Workingtimes.get_workingtime!(id)
    render(conn, "show.json", workingtime: workingtime)
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = Workingtimes.get_workingtime!(id)

    with {:ok, %Workingtime{} = workingtime} <- Workingtimes.update_workingtime(workingtime, workingtime_params) do
      render(conn, "show.json", workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Workingtimes.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- Workingtimes.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end

  def add_user_working_time(conn, %{"workingtime" => workingtime_params, "userID" => id}) do
    with {:ok, %Workingtime{} = workingtime} <- Workingtimes.create_workingtime(Map.put(workingtime_params, "user", id)) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", Routes.workingtime_path(conn, :show, workingtime))
      |> render("show.json", workingtime: workingtime)
    end
  end

  def get_one_working_time(conn, %{"userID" => userId, "id" => id}) do
    userWorkingtime = Workingtimes.get_user_workingtime(userId, id)
    render(conn, "show.json", workingtime: userWorkingtime)
    # IO.inspect(userWorkingtime)
    # workingtime = userWorkingtime.getWorkingtime!(id)
    # render(conn, "show.json", workingtime: workingtime)
  end

  def get_multiple_working_time(conn, _params) do
    startDate = Map.get(conn.query_params, "start")
    endDate = Map.get(conn.query_params, "end")

    cond do
      !is_nil(startDate) && !is_nil(endDate) -> 
        render(conn, "index.json", workingtimes: Workingtimes.get_user_workingtime_by_start_and_end(startDate, endDate))
      !is_nil(startDate) ->
        render(conn, "index.json", workingtimes: Workingtimes.get_user_workingtime_by_start(startDate))
      !is_nil(endDate) ->
        render(conn, "index.json", workingtimes: Workingtimes.get_user_workingtime_by_end(endDate))
      true ->
        put_status(conn, :bad_request) |> json(%{data: %{message: "At least start date or end date is required"}})   
    end
  end
end