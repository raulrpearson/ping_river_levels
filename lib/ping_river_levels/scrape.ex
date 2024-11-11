defmodule PingRiverLevels.Scrape do
  @min_scrape_datetime DateTime.new!(~D[2024-07-10], ~T[00:00:00], "Asia/Bangkok")

  alias PingRiverLevels.Scrape.Worker

  def build_queries(measurements) do
    measurements
    |> Enum.reverse()
    |> Stream.filter(fn %{datetime: datetime, level: level, discharge: discharge} ->
      DateTime.after?(datetime, @min_scrape_datetime) and
        DateTime.diff(datetime, DateTime.now!("Asia/Bangkok"), :minute) <= -5 and
        (level == nil or discharge == nil)
    end)
    |> Enum.reduce([], fn
      %{datetime: datetime}, [] ->
        [to_thai_date(datetime)]

      %{datetime: datetime}, acc ->
        date = to_thai_date(datetime)
        [latest_date | _] = acc

        if Date.before?(date, Date.shift(latest_date, day: -2)) do
          [date | acc]
        else
          acc
        end
    end)
    |> Enum.map(fn date ->
      %{"station_id1" => "P.1", "station_id2" => "P.67", "date" => Date.to_iso8601(date)}
    end)
  end

  def schedule_queries(queries) do
    for {query, idx} <- Enum.with_index(queries) do
      Worker.new(query, schedule_in: idx * 15)
    end
    |> Oban.insert_all()
  end

  defp to_thai_date(datetime) do
    datetime
    |> DateTime.shift_zone!("Asia/Bangkok")
    |> DateTime.to_date()
  end
end
