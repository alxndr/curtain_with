defmodule CurtainWith.SetlistView do
  use CurtainWith.Web, :view

  def render("show.json", %{data: data}) do
    %{
      data: data,
    }
  end
end
