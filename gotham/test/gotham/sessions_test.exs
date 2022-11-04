defmodule Gotham.SessionsTest do
  use Gotham.DataCase

  alias Gotham.Sessions

  describe "sessions" do
    alias Gotham.Sessions.Session

    import Gotham.SessionsFixtures

    @invalid_attrs %{xrsf_token: nil}

    test "list_sessions/0 returns all sessions" do
      session = session_fixture()
      assert Sessions.list_sessions() == [session]
    end

    test "get_session!/1 returns the session with given id" do
      session = session_fixture()
      assert Sessions.get_session!(session.id) == session
    end

    test "create_session/1 with valid data creates a session" do
      user = Gotham.UsersFixtures.user_fixture()
      valid_attrs = %{xrsf_token: "some xrsf_token", user_id: user.id}

      assert {:ok, %Session{} = session} = Sessions.create_session(valid_attrs)
      assert session.xrsf_token == "some xrsf_token"
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sessions.create_session(@invalid_attrs)
    end

    test "update_session/2 with valid data updates the session" do
      session = session_fixture()
      update_attrs = %{xrsf_token: "some updated xrsf_token"}

      assert {:ok, %Session{} = session} = Sessions.update_session(session, update_attrs)
      assert session.xrsf_token == "some updated xrsf_token"
    end

    test "update_session/2 with invalid data returns error changeset" do
      session = session_fixture()
      assert {:error, %Ecto.Changeset{}} = Sessions.update_session(session, @invalid_attrs)
      assert session == Sessions.get_session!(session.id)
    end

    test "delete_session/1 deletes the session" do
      session = session_fixture()
      assert {:ok, %Session{}} = Sessions.delete_session(session)
      assert_raise Ecto.NoResultsError, fn -> Sessions.get_session!(session.id) end
    end

    test "change_session/1 returns a session changeset" do
      session = session_fixture()
      assert %Ecto.Changeset{} = Sessions.change_session(session)
    end
  end
end
