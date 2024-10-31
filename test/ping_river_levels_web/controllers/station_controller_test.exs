defmodule PingRiverLevelsWeb.StationControllerTest do
  use PingRiverLevelsWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all stations", %{conn: conn} do
      conn = get(conn, ~p"/api/stations")
      assert json_response(conn, 200)["data"] == []
    end
  end
end
