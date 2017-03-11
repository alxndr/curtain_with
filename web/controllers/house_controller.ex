defmodule CurtainWith.HouseController do
  use CurtainWith.Web, :controller

  alias CurtainWith.House

  def index(conn, _params) do
    houses = Repo.all(House)
    render(conn, "index.json", houses: houses)
  end

  def create(conn, %{"house" => house_params}) do
    changeset = House.changeset(%House{}, house_params)

    case Repo.insert(changeset) do
      {:ok, house} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", house_path(conn, :show, house))
        |> render("show.json", house: house)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(CurtainWith.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    house = Repo.get!(House, id)
    render(conn, "show.json", house: house)
  end

  def update(conn, %{"id" => id, "house" => house_params}) do
    house = Repo.get!(House, id)
    changeset = House.changeset(house, house_params)

    case Repo.update(changeset) do
      {:ok, house} ->
        render(conn, "show.json", house: house)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(CurtainWith.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    house = Repo.get!(House, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(house)

    send_resp(conn, :no_content, "")
  end
end
