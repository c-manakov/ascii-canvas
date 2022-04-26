defmodule CanvasWeb.MainControllerTest do
  use CanvasWeb.ConnCase, async: true

  test "should create a canvas", %{conn: conn} do
    conn = post(conn, Routes.main_path(conn, :create), %{width: 10, height: 10})
    assert body = json_response(conn, 200)
    assert is_binary(body["hash"]) == true
    assert is_integer(body["id"]) == true
    canvas_data = Jason.decode!(body["data"])
    assert canvas_data["canvas"]["0,6"] == ?\s
  end
end
