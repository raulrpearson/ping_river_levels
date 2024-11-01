defmodule PingRiverLevelsWeb.PageController do
  use PingRiverLevelsWeb, :controller

  alias PingRiverLevels.Water
  alias VegaLite, as: Vl

  def home(conn, params) do
    start_date =
      Map.get(params, "start_date", Date.utc_today() |> Date.shift(day: -1) |> Date.to_iso8601())

    start_datetime =
      DateTime.new!(
        Date.from_iso8601!(start_date),
        ~T[00:00:00.000],
        "Asia/Bangkok",
        Tz.TimeZoneDatabase
      )

    number_of_days =
      Map.get(params, "number_of_days", "2")

    station_ids =
      Map.get(params, "station_ids", ["P.1", "P.67"])

    measurements =
      Water.list_measurements(%{
        order_by: [:datetime, :station_id],
        filters: [
          %{field: :datetime, op: :>=, value: start_datetime},
          %{field: :station_id, op: :in, value: station_ids}
        ],
        limit: length(station_ids) * 24 * String.to_integer(number_of_days)
      })
      |> elem(1)
      |> elem(0)
      |> Enum.map(&Map.take(&1, [:datetime, :station_id, :level, :discharge]))

    spec =
      build_chart_spec(measurements)
      |> Jason.encode!()

    render(conn, :home,
      start_date: start_date,
      number_of_days: number_of_days,
      station_ids: station_ids,
      spec: spec,
      measurements: measurements
    )
  end

  def about(conn, _params) do
    render(conn, :about)
  end

  defp build_chart_spec(measurements) do
    Vl.new(autosize: "fit-x")
    |> Vl.data_from_values(measurements)
    |> Vl.concat(
      [
        Vl.new(
          title: "Level (m)",
          width: :container,
          height: 300
        )
        |> Vl.layers([
          Vl.new()
          |> Vl.encode_field(:x, "datetime",
            type: :temporal,
            # time_unit: "monthdatehours",
            axis: [{:title, nil}, {:labels, false}]
          )
          |> Vl.encode_field(:y, "level",
            type: :quantitative,
            axis: [{:title, nil}]
          )
          |> Vl.encode_field(:color, "station_id",
            type: :nominal,
            title: "Station",
            legend: [symbol_direction: "horizontal", orient: "top-right"]
          )
          |> Vl.layers([
            Vl.new()
            |> Vl.mark(:line, tooltip: true),
            Vl.new()
            |> Vl.param("label",
              select: [type: :point, encodings: [:x], nearest: true, on: "pointerover"]
            )
            |> Vl.mark(:point)
            |> Vl.encode(:opacity,
              condition: [param: "label", empty: false, value: 1],
              value: 0
            )
          ]),
          Vl.new()
          |> Vl.transform(filter: [param: "label", empty: false])
          |> Vl.layers([
            Vl.new()
            |> Vl.mark(:rule, color: "gray")
            |> Vl.encode_field(:x, "datetime",
              type: :temporal,
              time_unit: "monthdatehours",
              aggregate: "min"
            ),
            Vl.new()
            |> Vl.encode_field(:text, "level", type: :quantitative)
            |> Vl.encode_field(:x, "datetime", type: :temporal)
            |> Vl.encode_field(:y, "level", type: :quantitative)
            |> Vl.layers([
              Vl.new()
              |> Vl.mark(:text, stroke: "white", stroke_width: 2, align: "left", dx: 5, dy: -5),
              Vl.new()
              |> Vl.mark(:text, align: "left", dx: 5, dy: -5)
              |> Vl.encode_field(:color, "station_id", type: :nominal)
            ]),
            Vl.new()
            |> Vl.transform(filter: "datum.station_id == 'P.1'")
            |> Vl.encode_field(:text, "datetime", type: :temporal, format: "%b %d, %Y %H:%M")
            |> Vl.encode_field(:x, "datetime", type: :temporal)
            |> Vl.encode(:y, datum: 0)
            |> Vl.layers([
              Vl.new()
              |> Vl.mark(:text, stroke: "white", stroke_width: 2, align: "left", dx: 5, dy: -10),
              Vl.new()
              |> Vl.mark(:text, align: "left", dx: 5, dy: -10)
            ])
          ])
        ]),
        Vl.new(
          title: "Discharge (m3/s)",
          width: :container,
          height: 300
        )
        |> Vl.layers([
          Vl.new()
          |> Vl.encode_field(:x, "datetime",
            type: :temporal,
            # time_unit: "monthdatehours",
            axis: [{:title, nil}, {:label_angle, -90}]
          )
          |> Vl.encode_field(:y, "discharge",
            type: :quantitative,
            axis: [{:title, nil}]
          )
          |> Vl.encode_field(:color, "station_id",
            type: :nominal,
            title: "Station",
            legend: [symbol_direction: "horizontal", orient: "top-right"]
          )
          |> Vl.layers([
            Vl.new()
            |> Vl.mark(:line, tooltip: true),
            Vl.new()
            |> Vl.param("label",
              select: [type: :point, encodings: [:x], nearest: true, on: "pointerover"]
            )
            |> Vl.mark(:point)
            |> Vl.encode(:opacity,
              condition: [param: "label", empty: false, value: 1],
              value: 0
            )
          ]),
          Vl.new()
          |> Vl.transform(filter: [param: "label", empty: false])
          |> Vl.layers([
            Vl.new()
            |> Vl.mark(:rule, color: "gray")
            |> Vl.encode_field(:x, "datetime",
              type: :temporal,
              time_unit: "monthdatehours",
              aggregate: "min"
            ),
            Vl.new()
            |> Vl.encode_field(:text, "discharge", type: :quantitative)
            |> Vl.encode_field(:x, "datetime", type: :temporal)
            |> Vl.encode_field(:y, "discharge", type: :quantitative)
            |> Vl.layers([
              Vl.new()
              |> Vl.mark(:text, stroke: "white", stroke_width: 2, align: "left", dx: 5, dy: -5),
              Vl.new()
              |> Vl.mark(:text, align: "left", dx: 5, dy: -5)
              |> Vl.encode_field(:color, "station_id", type: :nominal)
            ]),
            Vl.new()
            |> Vl.transform(filter: "datum.station_id == 'P.1'")
            |> Vl.encode_field(:text, "datetime", type: :temporal, format: "%b %d, %Y %H:%M")
            |> Vl.encode_field(:x, "datetime", type: :temporal)
            |> Vl.encode(:y, datum: 0)
            |> Vl.layers([
              Vl.new()
              |> Vl.mark(:text, stroke: "white", stroke_width: 2, align: "left", dx: 5, dy: -10),
              Vl.new()
              |> Vl.mark(:text, align: "left", dx: 5, dy: -10)
            ])
          ])
        ])
      ],
      :vertical
    )
    |> Vl.to_spec()
  end
end
