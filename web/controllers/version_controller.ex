defmodule AtomTools.VersionController do
  use AtomTools.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, params) do
    version_info = params["version"]["info"]
    versions = parse_version(version_info)
    expected_version = get_electron_version(versions)

    render_for(conn, versions, expected_version)
  end

  defp format_url(tag), do: "https://raw.githubusercontent.com/atom/atom/#{tag}/package.json"

  defp get_electron_version(%{"Atom" => atom_version}) do
    atom_version
    |> get_tag
    |> format_url
    |> HTTPotion.get
    |> handle_response
  end

  defp handle_json({:ok, info}), do: info["electronVersion"]
  defp handle_json({:error, :invalid}), do: {:error, "The JSON was invalid"}
  defp handle_json({:error, {:invalid, message}}), do: {:error, "The JSON was invalid: #{message}"}

  defp handle_response(%{body: body, status_code: code}) when code != 200, do: {:error, body}
  defp handle_response(%{body: body}) do
    body
    |> Poison.decode
    |> handle_json
  end

  defp parse_version(info) do
    info
    |> String.split("\n")
    |> Enum.map(fn(text) -> String.split(text, ":") end)
    |> Enum.reduce(%{}, fn(pair, map) ->
         key = String.trim(List.first(pair))
         value = String.trim(List.last(pair))
         Map.put(map, key, value)
       end)
  end

  defp render_for(conn, _, {:error, message}) do
    render conn, "error.html", message: message
  end

  defp render_for(conn, versions, actual_version) do
    render conn, "show.html", atom_version: versions["Atom"], electron_version: versions["Electron"], actual_version: actual_version
  end

  defp get_tag(version) do
    version
    |> String.split("-")
    |> format_tag
  end

  defp format_tag(list = [_ | [ _ | sha]]) when length(list) == 3, do: sha
  defp format_tag(list = [version | [beta]]) when length(list) == 2, do: "v#{version}-#{beta}"
  defp format_tag([version]) when is_binary(version), do: "v#{version}"
end
