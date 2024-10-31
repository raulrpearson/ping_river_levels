defmodule PingRiverLevels.Water.Station do
  use Ecto.Schema
  import Ecto.Changeset

  alias PingRiverLevels.Water.Measurement

  @primary_key {:id, :string, autogenerate: false}
  schema "stations" do
    has_many :measurements, Measurement

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(station, attrs) do
    station
    |> cast(attrs, [:id])
    |> validate_required([:id])
  end
end
