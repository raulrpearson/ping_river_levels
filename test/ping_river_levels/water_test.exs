defmodule PingRiverLevels.WaterTest do
  use PingRiverLevels.DataCase

  alias PingRiverLevels.Water

  describe "stations" do
    alias PingRiverLevels.Water.Station

    import PingRiverLevels.WaterFixtures

    @invalid_attrs %{id: nil}

    test "list_stations/0 returns all stations" do
      station = station_fixture()
      assert Water.list_stations() == [station]
    end

    test "get_station!/1 returns the station with given id" do
      station = station_fixture()
      assert Water.get_station!(station.id) == station
    end

    test "create_station/1 with valid data creates a station" do
      valid_attrs = %{id: "some id"}

      assert {:ok, %Station{} = station} = Water.create_station(valid_attrs)
      assert station.id == "some id"
    end

    test "create_station/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Water.create_station(@invalid_attrs)
    end

    test "update_station/2 with valid data updates the station" do
      station = station_fixture()
      update_attrs = %{id: "some updated id"}

      assert {:ok, %Station{} = station} = Water.update_station(station, update_attrs)
      assert station.id == "some updated id"
    end

    test "update_station/2 with invalid data returns error changeset" do
      station = station_fixture()
      assert {:error, %Ecto.Changeset{}} = Water.update_station(station, @invalid_attrs)
      assert station == Water.get_station!(station.id)
    end

    test "delete_station/1 deletes the station" do
      station = station_fixture()
      assert {:ok, %Station{}} = Water.delete_station(station)
      assert_raise Ecto.NoResultsError, fn -> Water.get_station!(station.id) end
    end

    test "change_station/1 returns a station changeset" do
      station = station_fixture()
      assert %Ecto.Changeset{} = Water.change_station(station)
    end
  end
end
