defmodule PingRiverLevels.WaterFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PingRiverLevels.Water` context.
  """

  @doc """
  Generate a station.
  """
  def station_fixture(attrs \\ %{}) do
    {:ok, station} =
      attrs
      |> Enum.into(%{
        id: "some id"
      })
      |> PingRiverLevels.Water.create_station()

    station
  end

  @doc """
  Generate a measurement.
  """
  def measurement_fixture(attrs \\ %{}) do
    station = station_fixture()

    {:ok, measurement} =
      attrs
      |> Enum.into(%{
        datetime: ~U[2024-10-30 12:23:00Z],
        discharge: 120.5,
        level: 120.5,
        station_id: station.id
      })
      |> PingRiverLevels.Water.create_measurement()

    measurement
  end
end
