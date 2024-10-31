defmodule PingRiverLevels.Repo do
  use Ecto.Repo,
    otp_app: :ping_river_levels,
    adapter: Ecto.Adapters.SQLite3
end
