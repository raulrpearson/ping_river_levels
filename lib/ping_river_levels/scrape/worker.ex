defmodule PingRiverLevels.Scrape.Worker do
  use Oban.Worker

  alias PingRiverLevels.{HydroApi, Water}

  @impl Oban.Worker
  def perform(%Oban.Job{args: params}) do
    params
    |> HydroApi.query()
    |> Enum.each(&Water.create_measurement/1)

    :ok
  end
end
