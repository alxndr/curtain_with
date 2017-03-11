defmodule CurtainWith.HouseControllerTest do
  use CurtainWith.ConnCase

  alias CurtainWith.House
  @valid_attrs %{book: %{}, name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, house_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    house = Repo.insert! %House{}
    conn = get conn, house_path(conn, :show, house)
    assert json_response(conn, 200)["data"] == %{"id" => house.id,
      "name" => house.name,
      "book" => house.book}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, house_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, house_path(conn, :create), house: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(House, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, house_path(conn, :create), house: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    house = Repo.insert! %House{}
    conn = put conn, house_path(conn, :update, house), house: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(House, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    house = Repo.insert! %House{}
    conn = put conn, house_path(conn, :update, house), house: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    house = Repo.insert! %House{}
    conn = delete conn, house_path(conn, :delete, house)
    assert response(conn, 204)
    refute Repo.get(House, house.id)
  end
end
