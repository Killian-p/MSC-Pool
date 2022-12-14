defmodule Gotham.WorkingtimesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gotham.Workingtimes` context.
  """

  @doc """
  Generate a workingtime.
  """
  def workingtime_fixture(attrs \\ %{}) do
  user = Gotham.UsersFixtures.user_fixture()
    {:ok, workingtime} =
      attrs
      |> Enum.into(%{
        end: ~U[2022-10-24 11:47:00Z],
        start: ~U[2022-10-24 11:47:00Z],
        user: user.id
      })
      |> Gotham.Workingtimes.create_workingtime()

    workingtime
  end
end
