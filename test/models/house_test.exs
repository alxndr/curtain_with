defmodule CurtainWith.HouseTest do
  use CurtainWith.ModelCase

  alias CurtainWith.House

  @valid_attrs %{book: %{}, name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = House.changeset(%House{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = House.changeset(%House{}, @invalid_attrs)
    refute changeset.valid?
  end
end
