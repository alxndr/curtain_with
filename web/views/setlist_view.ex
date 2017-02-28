defmodule CurtainWith.SetlistView do
  use CurtainWith.Web, :view

  def render("show.json", %{date: date}) do
    %{
      date: date,
    }
  end
end
