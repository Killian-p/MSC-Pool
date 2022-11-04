defmodule GothamWeb.UserController do
  use GothamWeb, :controller

  alias Gotham.Users
  alias Gotham.Users.User
  alias Bcrypt.Base
  alias Gotham.Sessions
  alias Gotham.Sessions.Session

  action_fallback GothamWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"userID" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"userID" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"userID" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_user_by_query_params(conn, _params) do
    username = Map.get(conn.query_params, "username")
    email = Map.get(conn.query_params, "email")

    cond do
      !is_nil(username) && !is_nil(email) -> 
        render(conn, "index.json", users: Users.get_user_by_mail_and_username(username, email))
      !is_nil(username) ->
        render(conn, "index.json", users: Users.get_user_by_username(username))
      !is_nil(email) ->
        render(conn, "index.json", users: Users.get_user_by_mail(email))
      true ->
        put_status(conn, :bad_request) |> json(%{message: "At least username or email is required"})
    end
  end

  def signup(conn, %{"user" => user_params}) do
    user = Users.get_user_by_mail(user_params["email"])
    cond do
      user != [] ->
        put_status(conn, :forbidden) |> json(%{message: "An account already exist with this email"})
      true ->
        with {:ok, %User{} = user} <- Users.create_user(Map.replace!(user_params, "password", Bcrypt.Base.hash_password(user_params["password"], Bcrypt.Base.gen_salt(12, true)))) do
          conn
          |> put_status(:created)
          |> render("create_user.json", user: user, token: GothamWeb.Token.create_jwt_token(user))
        end
    end
  end

  def signin(conn, %{"email" => email, "password" => password}) do
    user = Users.get_user_by_mail_and_password(email, Bcrypt.Base.hash_password(password, Bcrypt.Base.gen_salt(12, true)))
    cond do 
      !is_nil(user) ->
        render(conn, "create_user.json", user: user, token: GothamWeb.Token.create_jwt_token(user))
      true ->
        put_status(conn, :forbidden) |> json(%{message: "Invalid credentials"})
    end
  end

  def logout(conn, %{"user_id" => user_id}) do
    token = get_req_header(conn, "token")
    IO.inspect GothamWeb.Token.is_token_valid(List.first(token), ["ADMIN", "MANAGER", "EMPLOYEE"])

    user_session = Sessions.get_sessions_by_user_id(user_id)

    cond do
      !is_nil(user_session) ->
        session = Sessions.get_session!(user_session.id)
        with {:ok, %Session{}} <- Sessions.delete_session(session) do
          send_resp(conn, :no_content, "")
        end
      true ->
        put_status(conn, :bad_request) |> json(%{message: "User is not connected"})
    end
  end
end
