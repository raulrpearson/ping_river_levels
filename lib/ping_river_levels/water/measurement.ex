defmodule PingRiverLevels.Water.Measurement do
  use Ecto.Schema
  import Ecto.Changeset

  alias PingRiverLevels.Water.Station

  @derive {
    Flop.Schema,
    filterable: [:datetime, :level, :discharge, :station_id],
    sortable: [:datetime, :level, :discharge, :station_id]
  }

  schema "measurements" do
    field :level, :float
    field :datetime, :utc_datetime
    field :discharge, :float
    belongs_to :station, Station, type: :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(measurement, attrs) do
    measurement
    |> cast(attrs, [:datetime, :level, :discharge, :station_id])
    |> validate_required([:datetime, :level, :discharge, :station_id])
    |> assoc_constraint(:station)
  end
end
