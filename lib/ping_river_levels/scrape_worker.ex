defmodule PingRiverLevels.ScrapeWorker do
  use Oban.Worker

  alias PingRiverLevels.{HydroApi, Water}

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    {:ok, {latest, _meta}} =
      Water.list_measurements(%{limit: 1, order_by: [:datetime], order_directions: [:desc]})

    case latest do
      [] ->
        scrape_latest()

      [latest | _] ->
        if DateTime.diff(DateTime.utc_now(), latest.datetime, :minute) > 60, do: scrape_latest()
    end

    :ok
  end

  defp scrape_latest() do
    HydroApi.query(%{
      station_id1: "P.1",
      station_id2: "P.67",
      date:
        DateTime.utc_now()
        |> DateTime.shift_zone!("Asia/Bangkok", Tz.TimeZoneDatabase)
        |> DateTime.to_date()
        |> to_string()
    })
    |> Enum.each(&Water.create_measurement/1)
  end
end
