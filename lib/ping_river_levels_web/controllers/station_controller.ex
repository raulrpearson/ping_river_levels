defmodule PingRiverLevelsWeb.StationController do
  use PingRiverLevelsWeb, :controller

  alias PingRiverLevels.Water

  action_fallback PingRiverLevelsWeb.FallbackController

  def index(conn, _params) do
    stations = Water.list_stations()
    render(conn, :index, stations: stations)
  end

  def show(conn, %{"id" => id}) do
    station = Water.get_station!(id)
    render(conn, :show, station: station)
  end
end
