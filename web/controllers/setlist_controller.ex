defmodule CurtainWith.SetlistController do
  use CurtainWith.Web, :controller

  @api_key Application.get_env(:curtain_with, :api_key)

  def show(conn, %{"date" => date}) do
    date
    |> construct_url
    |> fetch
    |> do_render(conn)
  end

  def construct_url(date), do: "https://api.phish.net/v3/setlists/get?showdate=#{date}&apikey=#{@api_key}"

  @spec fetch(String.t) :: %{} | String.t
  def fetch(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode!(body)["response"]["data"]
        |> tailor_data
      {:ok, %HTTPoison.Response{status_code: 404}} -> "404 not found" # TODO the .net api doesn't return 404s...
      {:error, %HTTPoison.Error{reason: reason}} -> "Error: #{reason}"
    end
  end

  @spec tailor_data([%{}] | any()) :: %{}
  def tailor_data([%{"setlistdata" => setlist_data} = show_data]) do
    setlist =
      setlist_data
      |> escape_segues
      |> strip_title_attributes
      |> extract_elements
      |> turn_into_arrays
    Map.put(show_data, "setlist", setlist)
    |> Map.delete("setlistdata")
  end
  def tailor_data([show_data]) do
    IO.puts "******* Show data is missing 'setlistdata' key:"
    IO.inspect show_data
  end
  def tailor_data(unrecognized_data) do
    IO.puts "****** Unrecognized data shape!"
    IO.inspect unrecognized_data
  end

  def escape_segues(wacky_html) do
    String.replace(wacky_html, " > ", " &gt; ")
  end

  def strip_title_attributes(wacky_html) do
    Regex.replace(~r{ title=(['"]).+?\1(>|\s+\w+=)}, wacky_html, "\\2")
  end

  # extracts just the elements for set markers and songs
  # each element is of the shape {tag, [{attribute, value},], [contents,]}
  def extract_elements(less_wacky_html) do
    Floki.find(less_wacky_html, ".set-label, a")
  end

  def turn_into_arrays(floki_tuples) do
    Enum.reduce(floki_tuples, %{}, &reduce_tuples_to_map/2)
    |> Map.delete(:current_set)
  end

  def reduce_tuples_to_map({tag, _, [set_label]}, acc) when tag === "span" do
    Map.merge acc, %{:current_set => set_label, set_label => []}
  end
  def reduce_tuples_to_map({tag, _, [song_title]}, acc) when tag === "a" do
    Map.put(acc, acc.current_set, append(Map.get(acc, acc.current_set), song_title))
  end
  def reduce_tuples_to_map(floki_tuple) do
    IO.puts "!!!!!!! Unrecognized Floki tuple!"
    IO.inspect floki_tuple
  end

  def append(list, element) do
    list
    |> Enum.reverse
    |> Enum.reverse([element])
  end

  def do_render(data, conn) do
    render conn, "show.json", data: data
  end
end
