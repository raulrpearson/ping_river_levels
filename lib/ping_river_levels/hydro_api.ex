defmodule PingRiverLevels.HydroApi do
  @url "https://hydro1.ddns.net/main/information_4/houly/water_today_report.php"
  @user_agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.3"

  @doc """
  Queries the Thai water levels API.

  Takes a map with `station_id1`, `station_id2` and `date` fields.
  """
  def query(params) do
    Req.get!(@url, headers: [{"user-agent", @user_agent}], params: params).body
    |> Jason.decode!()
    |> Enum.flat_map(fn x ->
      hour =
        x["hours_lv"]
        |> Integer.parse()
        |> elem(0)
        |> then(fn hour -> if hour == 24, do: 0, else: hour end)

      station_ids = [params["station_id1"], params["station_id2"]]

      dates =
        for i <- if(hour == 0, do: 1..-1//-1, else: 0..-2//-1) do
          Date.from_iso8601!(params["date"]) |> Date.shift(day: i)
        end

      for station <- Enum.with_index(station_ids, 1), date <- Enum.with_index(dates, 1) do
        {station_id, station_idx} = station
        {date, day_idx} = date
        level = x["level#{station_idx}_day#{day_idx}"]
        discharge = x["dischg#{station_idx}_day#{day_idx}"]

        if level == "" or discharge == "" do
          nil
        else
          %{
            station_id: station_id,
            datetime:
              DateTime.new!(date, Time.new!(hour, 0, 0), "Asia/Bangkok")
              |> DateTime.shift_zone!("Etc/UTC"),
            level: level |> Float.parse() |> elem(0),
            discharge: discharge |> Float.parse() |> elem(0)
          }
        end
      end
    end)
    |> Enum.filter(fn x -> x end)
  end
end
