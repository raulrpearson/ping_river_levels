defmodule PingRiverLevelsWeb.MeasurementController do
  use PingRiverLevelsWeb, :controller

  alias PingRiverLevels.Water

  action_fallback PingRiverLevelsWeb.FallbackController

  def index(conn, params) do
    {:ok, {measurements, _flop_meta}} = Water.list_measurements(params)
    render(conn, :index, measurements: measurements)
  end

  def show(conn, %{"id" => id}) do
    measurement = Water.get_measurement!(id)
    render(conn, :show, measurement: measurement)
  end
end
