defmodule Gotham.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gotham.Teams` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{

      })
      |> Gotham.Teams.create_team()

    team
  end
end
