defmodule CurtainWith.Router do
  use CurtainWith.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CurtainWith do
    pipe_through :api
    get "/setlists/get", SetlistController, :show
  end
end
