defmodule GothamWeb.UserView do
  use GothamWeb, :view
  alias GothamWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      roles: user.roles
    }
  end

  def render("create_user.json", %{user: user, token: token}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      roles: user.roles,
      token: token
    }
  end
end
