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
    token = get_req_header(conn, "token")

    cond do
      GothamWeb.Token.is_token_valid(List.first(token), ["ADMIN"]) && Map.has_key?(user_params, "roles") ->
        user = Users.get_user!(id)
        cond do
          user_params["roles"] == "EMPLOYEE" || user_params["roles"] == "MANAGER" ->
            with {:ok, %User{} = user} <- Users.update_user_roles(user, user_params) do
              render(conn, "show.json", user: user)
            end
          true ->
            put_status(conn, :bad_request) |> json(%{message: "Only roles EMPLOYEE or MANAGER are authorized"})
        end
      GothamWeb.Token.is_token_valid(List.first(token), ["EMPLOYEE", "MANAGER", "ADMIN"]) ->
        user = Users.get_user!(id)
        with {:ok, claims} <- GothamWeb.Token.get_token_data(List.first(token)) do
          cond do
            user.id == claims["user_id"] ->
              with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
                render(conn, "show.json", user: user)
              end
            true ->
              put_status(conn, :unauthorized) |> json(%{message: "You're not authorized to perform this action"})
          end
        end
      true ->
        put_status(conn, :unauthorized) |> json(%{message: "You're not authorized to perform this action"})
    end
  end

  def delete(conn, %{"userID" => id}) do
    token = get_req_header(conn, "token")
    user = Users.get_user!(id)

    cond do
      GothamWeb.Token.is_token_valid(List.first(token), ["ADMIN"]) ->
        with {:ok, %User{}} <- Users.delete_user(user) do
          send_resp(conn, :no_content, "")
        end
      true ->
        put_status(conn, :unauthorized) |> json(%{message: "You're not authorized to perform this action"})
    end
  end

  def get_user_by_query_params(conn, _params) do
    token = get_req_header(conn, "token")
    username = Map.get(conn.query_params, "username")
    email = Map.get(conn.query_params, "email")

    cond do
      GothamWeb.Token.is_token_valid(List.first(token), ["ADMIN", "EMPLOYEE"]) ->
        cond do
          is_nil(username) && is_nil(email) && GothamWeb.Token.is_token_valid(List.first(token), ["ADMIN"]) ->
            render(conn, "index.json", users: Users.list_users())
          !is_nil(username) && !is_nil(email) ->
            render(conn, "index.json", users: Users.get_user_by_mail_and_username(username, email))
          !is_nil(username) ->
            render(conn, "index.json", users: Users.get_user_by_username(username))
          !is_nil(email) ->
            render(conn, "index.json", users: Users.get_user_by_mail(email))
          true ->
            put_status(conn, :bad_request) |> json(%{message: "At least username or email is required"})
        end
      true ->
        put_status(conn, :unauthorized) |> json(%{message: "You're not authorized to perform this action"})
    end
  end

  def signup(conn, %{"user" => user_params}) do
    user = Users.get_user_by_mail(user_params["email"])
    cond do
      user != [] ->
        put_status(conn, :forbidden) |> json(%{message: "An account already exist with this email"})
      true ->
        with {:ok, %User{} = user} <- Users.create_user(Map.replace!(user_params, "password", Bcrypt.Base.hash_password(user_params["password"], "$2a$12$LKwz97FK3Xnnvlidn/Y9w."))) do
          conn
          |> put_status(:created)
          |> render("create_user.json", user: user, token: GothamWeb.Token.create_jwt_token(user))
        end
    end
  end

  def signin(conn, %{"email" => email, "password" => password}) do
    user = Users.get_user_by_mail_and_password(email, Bcrypt.Base.hash_password(password, "$2a$12$LKwz97FK3Xnnvlidn/Y9w."))
    cond do
      !is_nil(user) ->
        render(conn, "create_user.json", user: user, token: GothamWeb.Token.create_jwt_token(user))
      true ->
        put_status(conn, :forbidden) |> json(%{message: "Invalid credentials"})
    end
  end

  def logout(conn, %{"user_id" => user_id}) do
    token = get_req_header(conn, "token")

    cond do
      GothamWeb.Token.is_token_valid(List.first(token), ["ADMIN", "MANAGER", "EMPLOYEE"]) ->
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
      true ->
        put_status(conn, :unauthorized) |> json(%{message: "You're not authorized to perform this action"})
    end
  end
end
