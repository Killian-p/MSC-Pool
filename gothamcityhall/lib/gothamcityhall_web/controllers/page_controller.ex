defmodule GothamcityhallWeb.PageController do
  use GothamcityhallWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
