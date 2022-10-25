defmodule GothamcityWeb.PageController do
  use GothamcityWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
