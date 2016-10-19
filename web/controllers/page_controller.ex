defmodule AtomTools.PageController do
  use AtomTools.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
