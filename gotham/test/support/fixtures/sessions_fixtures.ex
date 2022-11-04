defmodule Gotham.SessionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gotham.Sessions` context.
  """

  @doc """
  Generate a session.
  """
  def session_fixture(attrs \\ %{}) do
    user = Gotham.UsersFixtures.user_fixture()
    {:ok, session} =
      attrs
      |> Enum.into(%{
        xrsf_token: "some xrsf_token",
        user_id: user.id
      })
      |> Gotham.Sessions.create_session()

    session
  end
end
