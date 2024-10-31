defmodule PingRiverLevels.Water.Station do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  schema "stations" do
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(station, attrs) do
    station
    |> cast(attrs, [:id])
    |> validate_required([:id])
  end
end
