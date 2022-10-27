defmodule GothamWeb.UserController do
  use GothamWeb, :controller

  alias Gotham.Users
  alias Gotham.Users.User

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
        put_status(conn, :bad_request) |> json(%{data: %{message: "At least username or email is required"}})   
    end
  end
end


# user = Users.get_user_by_mail_and_username(username, email)
# render(conn, "show.json", user: user)

# user = Users.get_user_by_username(username)
# render(conn, "show.json", user: user)

# user = Users.get_user_by_mail(email)
# render(conn, "show.json", user: user)


# user = Users.get_user_by_params(username, email)
# render(conn, "show.json", user: user)