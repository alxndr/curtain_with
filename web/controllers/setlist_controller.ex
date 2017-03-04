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
      |> swap_segues
      |> sanitize_title_attributes
      |> extract_elements
      |> Enum.reduce(%{}, &reduce_tuples_to_map_of_sets/2)
      |> Map.delete(:current_set)
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

  def swap_segues(wacky_html) do
    Regex.replace(~r{(</a>)( -?>) }, wacky_html, "\\2\\1 ")
  end

  def sanitize_title_attributes(wacky_html) do
    Regex.replace(~r{ title=(['"])(.+?)\1(>|\s+\w+=)}, wacky_html, " title=\"\\2\"\\3")
  end

  # extracts just the elements for set markers and songs
  # each element is of the shape {tag, [{attribute, value},], [contents,]}
  def extract_elements(less_wacky_html) do
    Floki.find(less_wacky_html, ".set-label, a")
  end

  # sets a bit of state. we are processing songs in played order, so
  # the :current_set value tracks what set label we have most recently encountered.
  # songs will be identified with this set until another set label is encountered.
  def reduce_tuples_to_map_of_sets({tag, _, [set_label]}, acc) when tag === "span" do
    Map.merge acc, %{:current_set => set_label, set_label => []}
  end
  def reduce_tuples_to_map_of_sets({tag, html_attributes_array, [song_title]}, acc) when tag === "a" do
    html_attributes_map = Enum.into(html_attributes_array, %{})
    song = build_song_map(song_title, html_attributes_map)
    transformed_set =
      acc
      |> Map.get(acc.current_set)
      |> append(song)
    Map.put acc, acc.current_set, transformed_set
  end
  def reduce_tuples_to_map_of_sets(floki_tuple) do
    IO.puts "!!!!!!! Unrecognized Floki tuple!"
    IO.inspect floki_tuple
  end

  def build_song_map(song_title, %{"title" => title_attribute}) do
    just_the_title = Regex.replace(~r{ -?>$}, song_title, "")
    title_attribute = String.trim(title_attribute)
    a_map = if title_attribute === just_the_title do
      %{title: just_the_title}
    else
      %{
        title: just_the_title,
        notes: title_attribute,
      }
    end
    cond do
      String.ends_with?(song_title, " ->") ->
        %{segue: "->"}
      String.ends_with?(song_title,  " >") ->
        %{segue: ">"}
      true ->
        %{}
    end
    |> Map.merge(a_map)
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
