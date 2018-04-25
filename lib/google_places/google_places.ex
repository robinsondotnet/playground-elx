defmodule GooglePlaces do
  @moduledoc false

  import Plug.Conn

  @endpoint "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
  @apikey "AIzaSyBjCajhGChy3IkBEr1VcK0456LbhIuMnfg"

  def get_location(search_text) do
    case http_get(search_text) do
      {:ok, body, _code} ->
        {:ok, body.results}
      err -> err
    end
  end

  def http_get(path), do: call(:get, path)

  def call(method, path) do
    {:ok , geo_response} = GeoIP.lookup("google.com")
    headers = [ {"content-type", "application/json"}]
    params = %{key: @apikey,
      location: "#{geo_response.latitude},#{geo_response.longitude}",
      radius: "50000",
      keyword: path}

    url("")
    |> HTTPoison.get(headers, params: params)
    |> handle_response
  end

  defp url(path), do: @endpoint <> path

  defp handle_reponse({:ok, response}), do: handle_status(response)

  defp handle_response(err), do: err

  defp handle_status(response) do
    case response.status_code do
      code when code in 200..299 ->
        {:ok, response.body, code}
      err ->
        {:error, response.body, err}
    end 
  end

end
