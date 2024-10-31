defmodule PingRiverLevels.Repo.Migrations.CreateStations do
  use Ecto.Migration

  def change do
    create table(:stations, primary_key: false) do
      add :id, :string, primary_key: true

      timestamps(type: :utc_datetime)
    end
  end
end
