defmodule Gothamcityhall.WorkFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gothamcityhall.Work` context.
  """

  @doc """
  Generate a workingtime.
  """
  def workingtime_fixture(attrs \\ %{}) do
    {:ok, workingtime} =
      attrs
      |> Enum.into(%{
        end: ~U[2022-10-24 08:52:00Z],
        start: ~U[2022-10-24 08:52:00Z]
      })
      |> Gothamcityhall.Work.create_workingtime()

    workingtime
  end
end
