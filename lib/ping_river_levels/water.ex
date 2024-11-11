defmodule PingRiverLevels.Water do
  @moduledoc """
  The Water context.
  """

  import Ecto.Query, warn: false
  alias PingRiverLevels.Repo

  alias PingRiverLevels.Water.Station

  @doc """
  Returns the list of stations.

  ## Examples

      iex> list_stations()
      [%Station{}, ...]

  """
  def list_stations(params \\ %{}) do
    Flop.validate_and_run(Station, params, for: Station)
  end

  @doc """
  Gets a single station.

  Raises `Ecto.NoResultsError` if the Station does not exist.

  ## Examples

      iex> get_station!(123)
      %Station{}

      iex> get_station!(456)
      ** (Ecto.NoResultsError)

  """
  def get_station!(id), do: Repo.get!(Station, id)

  @doc """
  Creates a station.

  ## Examples

      iex> create_station(%{field: value})
      {:ok, %Station{}}

      iex> create_station(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_station(attrs \\ %{}) do
    %Station{}
    |> Station.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a station.

  ## Examples

      iex> update_station(station, %{field: new_value})
      {:ok, %Station{}}

      iex> update_station(station, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_station(%Station{} = station, attrs) do
    station
    |> Station.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a station.

  ## Examples

      iex> delete_station(station)
      {:ok, %Station{}}

      iex> delete_station(station)
      {:error, %Ecto.Changeset{}}

  """
  def delete_station(%Station{} = station) do
    Repo.delete(station)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking station changes.

  ## Examples

      iex> change_station(station)
      %Ecto.Changeset{data: %Station{}}

  """
  def change_station(%Station{} = station, attrs \\ %{}) do
    Station.changeset(station, attrs)
  end

  alias PingRiverLevels.Water.Measurement

  @doc """
  Returns the list of measurements.

  ## Examples

      iex> list_measurements()
      [%Measurement{}, ...]

  """
  def list_measurements(params \\ %{}) do
    Flop.validate_and_run(Measurement, params, for: Measurement)
  end

  def query_measurements(%{from: from, to: to, station_ids: station_ids}) do
    {:ok, {measurements, _}} =
      list_measurements(%{
        order_by: [:datetime, :station_id],
        filters: [
          %{field: :datetime, op: :>=, value: from},
          %{field: :datetime, op: :<=, value: to},
          %{field: :station_id, op: :in, value: station_ids}
        ],
        # max out at 20 days for 2 stations, 40 days for one station
        limit: 24 * 20 * 2
      })

    Enum.flat_map(0..DateTime.diff(to, from, :hour), fn idx ->
      datetime = DateTime.shift(from, hour: idx)

      p1_measurement =
        case Enum.find(measurements, fn m -> m.station_id == "P.1" and m.datetime == datetime end) do
          nil -> %{datetime: datetime, station_id: "P.1", level: nil, discharge: nil}
          x -> Map.take(x, [:station_id, :datetime, :level, :discharge])
        end

      p67_measurement =
        case Enum.find(measurements, fn m -> m.station_id == "P.67" and m.datetime == datetime end) do
          nil -> %{datetime: datetime, station_id: "P.67", level: nil, discharge: nil}
          x -> Map.take(x, [:station_id, :datetime, :level, :discharge])
        end

      [p1_measurement, p67_measurement]
    end)
  end

  @doc """
  Gets a single measurement.

  Raises `Ecto.NoResultsError` if the Measurement does not exist.

  ## Examples

      iex> get_measurement!(123)
      %Measurement{}

      iex> get_measurement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_measurement!(id), do: Repo.get!(Measurement, id)

  @doc """
  Creates a measurement.

  ## Examples

      iex> create_measurement(%{field: value})
      {:ok, %Measurement{}}

      iex> create_measurement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_measurement(attrs \\ %{}) do
    %Measurement{}
    |> Measurement.changeset(attrs)
    |> Repo.insert(on_conflict: :nothing)
  end

  @doc """
  Updates a measurement.

  ## Examples

      iex> update_measurement(measurement, %{field: new_value})
      {:ok, %Measurement{}}

      iex> update_measurement(measurement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_measurement(%Measurement{} = measurement, attrs) do
    measurement
    |> Measurement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a measurement.

  ## Examples

      iex> delete_measurement(measurement)
      {:ok, %Measurement{}}

      iex> delete_measurement(measurement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_measurement(%Measurement{} = measurement) do
    Repo.delete(measurement)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking measurement changes.

  ## Examples

      iex> change_measurement(measurement)
      %Ecto.Changeset{data: %Measurement{}}

  """
  def change_measurement(%Measurement{} = measurement, attrs \\ %{}) do
    Measurement.changeset(measurement, attrs)
  end
end
