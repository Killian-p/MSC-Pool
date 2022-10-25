defmodule Gothamcityhall.TimeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gothamcityhall.Time` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~U[2022-10-24 08:54:00Z]
      })
      |> Gothamcityhall.Time.create_clock()

    clock
  end
end
