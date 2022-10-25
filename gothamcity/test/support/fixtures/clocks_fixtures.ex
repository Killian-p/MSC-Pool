defmodule Gothamcity.ClocksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gothamcity.Clocks` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~U[2022-10-24 11:13:00Z]
      })
      |> Gothamcity.Clocks.create_clock()

    clock
  end
end
