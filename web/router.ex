defmodule CurtainWith.Router do
  use CurtainWith.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CurtainWith do
    pipe_through :api
    get "/setlists/get", SetlistController, :show
  end

  scope "/", CurtainWith do
    resources "/houses", HouseController
    get "/house/find", HouseController, :find # `/house` so we don't conflict with the resources ^
  end
end
