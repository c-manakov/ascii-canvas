defmodule CanvasWeb.MainControllerTest do
  use CanvasWeb.ConnCase, async: true
  
  import Canvas.CanvasesFixtures

  test "should create a canvas", %{conn: conn} do
    conn = post(conn, Routes.main_path(conn, :create), %{width: 10, height: 10})
    assert body = json_response(conn, 200)
    assert is_binary(body["hash"]) == true
    assert is_integer(body["id"]) == true
    canvas_data = Jason.decode!(body["data"])
    assert canvas_data["canvas"]["0,6"] == ?\s
  end
  
  test "should get a canvas", %{conn: conn} do
    ascii_canvas = ascii_canvas_fixture()
    conn = get(conn, Routes.main_path(conn, :show, ascii_canvas.hash))
    assert body = json_response(conn, 200)
    assert body["hash"] == ascii_canvas.hash
  end
  
  test "should return 404 for non-existent canvas", %{conn: conn} do
    conn = get(conn, Routes.main_path(conn, :show, "not-a-hash"))
    assert body = json_response(conn, 404)
  end
end
