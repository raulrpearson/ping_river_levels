defmodule PingRiverLevelsWeb.MeasurementJSON do
  alias PingRiverLevels.Water.Measurement

  @doc """
  Renders a list of measurements.
  """
  def index(%{measurements: measurements}) do
    %{data: for(measurement <- measurements, do: data(measurement))}
  end

  @doc """
  Renders a single measurement.
  """
  def show(%{measurement: measurement}) do
    %{data: data(measurement)}
  end

  defp data(%Measurement{} = measurement) do
    %{
      id: measurement.id,
      datetime: measurement.datetime,
      level: measurement.level,
      discharge: measurement.discharge
    }
  end
end
