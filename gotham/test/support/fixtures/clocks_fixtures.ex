defmodule Gotham.ClocksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gotham.Clocks` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    user = Gotham.UsersFixtures.user_fixture()
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~U[2022-10-24 11:47:00Z],
        user: user.id
      })
      |> Gotham.Clocks.create_clock()

    clock
  end
end
