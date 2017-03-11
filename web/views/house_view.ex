defmodule CurtainWith.HouseView do
  use CurtainWith.Web, :view

  def render("index.json", %{houses: houses}) do
    %{data: render_many(houses, CurtainWith.HouseView, "house.json")}
  end

  def render("show.json", %{house: house}) do
    %{data: render_one(house, CurtainWith.HouseView, "house.json")}
  end

  def render("house.json", %{house: house}) do
    %{id: house.id,
      name: house.name,
      book: house.book}
  end
end
