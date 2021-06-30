defmodule DreamUpWeb.PageController do
  use DreamUpWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
