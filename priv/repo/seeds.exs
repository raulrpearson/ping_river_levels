# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PingRiverLevels.Repo.insert!(%PingRiverLevels.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PingRiverLevels.Water

Water.create_station(%{id: "P.1"})
Water.create_station(%{id: "P.67"})
