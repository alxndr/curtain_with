defmodule CurtainWith.PageController do
  use CurtainWith.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
