defmodule CurtainWith.SetlistController do
  use CurtainWith.Web, :controller

  @api_key Application.get_env(:curtain_with, :api_key)

  def show(conn, %{"date" => date}) do
    "https://api.phish.net/v3/setlists/get?showdate=#{date}&apikey=#{@api_key}"
    |> fetch
    |> do_render(conn)
  end

  def fetch(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> Poison.decode!(body)["response"]["data"]
      {:ok, %HTTPoison.Response{status_code: 404}} -> "404 not found" # TODO the .net api doesn't return 404s...
      {:error, %HTTPoison.Error{reason: reason}} -> "Error: #{reason}"
    end
  end

  def do_render(data, conn) do
    render conn, "show.json", data: data
  end
end
