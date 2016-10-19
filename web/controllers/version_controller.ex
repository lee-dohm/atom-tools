defmodule AtomTools.VersionController do
  use AtomTools.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, params) do
    version_info = params["version"]["info"]
    versions = parse(version_info)
    actual_version = get_electron_version_for(versions)

    render conn, "show.html", atom_version: versions["Atom"], electron_version: versions["Electron"], actual_version: actual_version
  end

  defp get_electron_version_for(%{"Atom" => atom_version}) do
    %{body: body, status_code: 200} = HTTPotion.get("https://raw.githubusercontent.com/atom/atom/v#{atom_version}/package.json")
    package_info = Poison.decode!(body)
    package_info["electronVersion"]
  end

  defp parse(info) do
    info
    |> String.split("\n")
    |> Enum.map(fn(text) -> String.split(text, ":") end)
    |> Enum.reduce(%{}, fn(pair, map) ->
         key = String.trim(List.first(pair))
         value = String.trim(List.last(pair))
         Map.put(map, key, value)
       end)
  end
end
