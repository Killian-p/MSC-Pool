defmodule Gotham.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gotham.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        username: "some username"
      })
      |> Gotham.Users.create_user()

    user
  end
end
