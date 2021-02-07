defmodule AtriaTask2Web.PageController do
  use AtriaTask2Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
