defmodule Gotham.Workingtimes do
  @moduledoc """
  The Workingtimes context.
  """

  import Ecto.Query, warn: false
  alias Gotham.Repo

  alias Gotham.Workingtimes.Workingtime

  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%Workingtime{}, ...]

  """
  def list_workingtimes do
    Repo.all(Workingtime)
  end

  @doc """
  Gets a single workingtime.

  Raises `Ecto.NoResultsError` if the Workingtime does not exist.

  ## Examples

      iex> get_workingtime!(123)
      %Workingtime{}

      iex> get_workingtime!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workingtime!(id), do: Repo.get!(Workingtime, id)

  @doc """
  Creates a workingtime.

  ## Examples

      iex> create_workingtime(%{field: value})
      {:ok, %Workingtime{}}

      iex> create_workingtime(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workingtime(attrs \\ %{}) do
    %Workingtime{}
    |> Workingtime.createset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workingtime.

  ## Examples

      iex> update_workingtime(workingtime, %{field: new_value})
      {:ok, %Workingtime{}}

      iex> update_workingtime(workingtime, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workingtime(%Workingtime{} = workingtime, attrs) do
    workingtime
    |> Workingtime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a workingtime.

  ## Examples

      iex> delete_workingtime(workingtime)
      {:ok, %Workingtime{}}

      iex> delete_workingtime(workingtime)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workingtime(%Workingtime{} = workingtime) do
    Repo.delete(workingtime)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workingtime changes.

  ## Examples

      iex> change_workingtime(workingtime)
      %Ecto.Changeset{data: %Workingtime{}}

  """
  def change_workingtime(%Workingtime{} = workingtime, attrs \\ %{}) do
    Workingtime.changeset(workingtime, attrs)
  end


  def get_user_workingtime(userID, workingtimeID) do
    workId = String.to_integer(workingtimeID)
    userId = String.to_integer(userID)

    Repo.one(from worktime in "workingtimes",
      where: worktime.user == ^userId and worktime.id == ^workId,
      select: [:start, :id, :end]
    )
  end

  def get_user_workingtime_by_start_and_end(userId, startDate, endDate) do
    id = String.to_integer(userId)

    Repo.all(from worktime in "workingtimes",
      where: worktime.start > ^startDate and worktime.end < ^endDate and worktime.user == ^id,
      select: [:start, :id, :end]
    )
  end

  def get_user_workingtime_by_start(userId, startDate) do
    # IO.inspect convert(startDate, Calendar.Gregorian)
    # IO.inspect Date.utc_today()
    # start = NaiveDateTime.from_iso8601(startDate)
    # {:ok, date} = NaiveDateTime.from_iso8601(startDate)
    # IO.inspect startDate

    # case NaiveDateTime.from_iso8601(startDate) do
    #   {:ok, date} ->
    id = String.to_integer(userId)


    Repo.all(from worktime in "workingtimes",
      where: worktime.start > ^startDate and worktime.user == ^id,
      select: [:start, :id, :end]
    )
      # {:error, _} ->

    # end

    # with {:ok, date} <- NaiveDateTime.from_iso8601(startDate) do
    #   Repo.all(from worktime in "workingtimes",
    #   where: worktime.start > ^date,
    #   select: [:start, :id, :end]
    # )
      # conn
      # |> put_status(:created)
      # # |> put_resp_header("location", Routes.workingtime_path(conn, :show, workingtime))
      # |> render("show.json", workingtime: workingtime)
    # end
    # IO.inspect start
    # Repo.all(from worktime in "workingtimes",
    #   where: worktime.start > ^startDate,
    #   select: [:start, :id, :end]
    # )
  end

  def get_user_workingtime_by_end(userId, endDate) do
    id = String.to_integer(userId)

    Repo.all(from worktime in "workingtimes",
      where: worktime.end < ^endDate and worktime.user == ^id,
      select: [:start, :id, :end]
    )
  end
end