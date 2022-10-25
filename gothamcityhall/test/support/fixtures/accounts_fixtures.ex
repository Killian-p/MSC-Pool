defmodule Gothamcityhall.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gothamcityhall.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        firstname: "some firstname"
      })
      |> Gothamcityhall.Accounts.create_user()

    user
  end
end
