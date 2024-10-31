defmodule PingRiverLevelsWeb.MeasurementController do
  use PingRiverLevelsWeb, :controller

  alias PingRiverLevels.Water

  action_fallback PingRiverLevelsWeb.FallbackController

  def index(conn, _params) do
    measurements = Water.list_measurements()
    render(conn, :index, measurements: measurements)
  end

  def show(conn, %{"id" => id}) do
    measurement = Water.get_measurement!(id)
    render(conn, :show, measurement: measurement)
  end
end
