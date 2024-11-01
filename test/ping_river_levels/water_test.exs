defmodule PingRiverLevels.WaterTest do
  use PingRiverLevels.DataCase

  alias PingRiverLevels.Water

  describe "stations" do
    alias PingRiverLevels.Water.Station

    import PingRiverLevels.WaterFixtures

    @invalid_attrs %{id: nil}

    test "list_stations/0 returns all stations" do
      station = station_fixture()
      {:ok, {stations, _flop_meta}} = Water.list_stations()
      assert stations == [station]
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

  describe "measurements" do
    alias PingRiverLevels.Water.Measurement

    import PingRiverLevels.WaterFixtures

    @invalid_attrs %{level: nil, datetime: nil, discharge: nil, station_id: nil}

    test "list_measurements/0 returns all measurements" do
      measurement = measurement_fixture()
      {:ok, {measurements, _flop_meta}} = Water.list_measurements()
      assert measurements == [measurement]
    end

    test "get_measurement!/1 returns the measurement with given id" do
      measurement = measurement_fixture()
      assert Water.get_measurement!(measurement.id) == measurement
    end

    test "create_measurement/1 with valid data creates a measurement" do
      station = station_fixture()

      valid_attrs = %{
        level: 120.5,
        datetime: ~U[2024-10-30 12:23:00Z],
        discharge: 120.5,
        station_id: station.id
      }

      assert {:ok, %Measurement{} = measurement} = Water.create_measurement(valid_attrs)
      assert measurement.level == 120.5
      assert measurement.datetime == ~U[2024-10-30 12:23:00Z]
      assert measurement.discharge == 120.5
      assert measurement.station_id == station.id
    end

    test "create_measurement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Water.create_measurement(@invalid_attrs)
    end

    test "update_measurement/2 with valid data updates the measurement" do
      measurement = measurement_fixture()
      update_attrs = %{level: 456.7, datetime: ~U[2024-10-31 12:23:00Z], discharge: 456.7}

      assert {:ok, %Measurement{} = measurement} =
               Water.update_measurement(measurement, update_attrs)

      assert measurement.level == 456.7
      assert measurement.datetime == ~U[2024-10-31 12:23:00Z]
      assert measurement.discharge == 456.7
    end

    test "update_measurement/2 with invalid data returns error changeset" do
      measurement = measurement_fixture()
      assert {:error, %Ecto.Changeset{}} = Water.update_measurement(measurement, @invalid_attrs)
      assert measurement == Water.get_measurement!(measurement.id)
    end

    test "delete_measurement/1 deletes the measurement" do
      measurement = measurement_fixture()
      assert {:ok, %Measurement{}} = Water.delete_measurement(measurement)
      assert_raise Ecto.NoResultsError, fn -> Water.get_measurement!(measurement.id) end
    end

    test "change_measurement/1 returns a measurement changeset" do
      measurement = measurement_fixture()
      assert %Ecto.Changeset{} = Water.change_measurement(measurement)
    end
  end
end
