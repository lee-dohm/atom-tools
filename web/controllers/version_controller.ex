defmodule AtomTools.VersionController do
  use AtomTools.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, params) do
    version_info = params["version"]["info"]
    {atom_version, electron_version} = parse(version_info)
    %{body: body, status_code: 200} = HTTPotion.get("https://raw.githubusercontent.com/atom/atom/v#{atom_version}/package.json")
    package_info = Poison.decode!(body)
    actual_version = package_info["electronVersion"]

    render conn, "show.html", atom_version: atom_version, electron_version: electron_version, actual_version: actual_version
  end

  defp parse(info) do
    versions = info
               |> String.split("\n")
               |> Enum.map(fn(text) -> String.split(text, ":") end)
               |> Enum.reduce(%{}, fn(pair, map) ->
                    key = String.trim(List.first(pair))
                    value = String.trim(List.last(pair))
                    Map.put(map, key, value)
                  end)

    {versions["Atom"], versions["Electron"]}
  end
end
