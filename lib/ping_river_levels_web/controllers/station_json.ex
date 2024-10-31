defmodule PingRiverLevelsWeb.StationJSON do
  alias PingRiverLevels.Water.Station

  @doc """
  Renders a list of stations.
  """
  def index(%{stations: stations}) do
    %{data: for(station <- stations, do: data(station))}
  end

  @doc """
  Renders a single station.
  """
  def show(%{station: station}) do
    %{data: data(station)}
  end

  defp data(%Station{} = station) do
    %{id: station.id}
  end
end
