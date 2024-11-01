defmodule PingRiverLevelsWeb.StationController do
  use PingRiverLevelsWeb, :controller

  alias PingRiverLevels.Water

  action_fallback PingRiverLevelsWeb.FallbackController

  def index(conn, params) do
    {:ok, {stations, _flop_meta}} = Water.list_stations(params)
    render(conn, :index, stations: stations)
  end

  def show(conn, %{"id" => id}) do
    station = Water.get_station!(id)
    render(conn, :show, station: station)
  end
end
