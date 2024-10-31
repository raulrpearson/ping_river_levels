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
end
