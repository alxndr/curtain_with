defmodule CurtainWith.SetlistController do
  use CurtainWith.Web, :controller

  def show(conn, %{"date" => date}) do
    render conn, "show.json", date: date
  end
end
