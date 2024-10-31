defmodule PingRiverLevels.Repo.Migrations.CreateMeasurements do
  use Ecto.Migration

  def change do
    create table(:measurements) do
      add :datetime, :utc_datetime
      add :level, :float
      add :discharge, :float
      add :station_id, references(:stations, type: :string, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:measurements, [:station_id])
  end
end
