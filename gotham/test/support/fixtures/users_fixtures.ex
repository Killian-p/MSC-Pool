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
        email: "test@test.fr",
        username: "some username",
        password: "password"
      })
      |> Gotham.Users.create_user()

    user
  end
end
