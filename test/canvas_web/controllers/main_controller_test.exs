defmodule CanvasWeb.MainControllerTest do
  use CanvasWeb.ConnCase, async: true

  import Canvas.CanvasesFixtures

  test "POST /canvas should create a canvas", %{conn: conn} do
    conn = post(conn, Routes.main_path(conn, :create), %{width: 10, height: 10})
    assert body = json_response(conn, 200)
    assert is_binary(body["hash"]) == true
    assert is_integer(body["id"]) == true
    canvas_data = Jason.decode!(body["data"])
    assert canvas_data["canvas"]["0,6"] == ?\s
  end

  test "GET /canvas/:hash should get a canvas", %{conn: conn} do
    ascii_canvas = ascii_canvas_fixture()
    conn = get(conn, Routes.main_path(conn, :show, ascii_canvas.hash))
    assert body = json_response(conn, 200)
    assert body["hash"] == ascii_canvas.hash
  end

  test "GET /canvas/:hash should return 404 for non-existent canvas", %{conn: conn} do
    conn = get(conn, Routes.main_path(conn, :show, "not-a-hash"))
    assert _body = json_response(conn, 404)
  end

  test "PUT /canvas/:hash/draw should draw on a canvas", %{conn: conn} do
    ascii_canvas = ascii_canvas_fixture()

    conn =
      put(conn, Routes.main_path(conn, :draw, ascii_canvas.hash), %{
        x: 0,
        y: 0,
        width: 8,
        height: 8,
        fill: "X",
        outline: "C"
      })

    assert body = json_response(conn, 200)

    canvas_data = Jason.decode!(body["data"])

    assert body["hash"] == ascii_canvas.hash
    assert canvas_data["canvas"]["3,3"] == ?X
  end

  test "PUT /canvas/:hash/draw should return an error for invalid input", %{conn: conn} do
    ascii_canvas = ascii_canvas_fixture()

    conn =
      put(conn, Routes.main_path(conn, :draw, ascii_canvas.hash), %{
        x: 0,
        y: 0,
        width: 8,
        height: 8,
      })

    assert _body = json_response(conn, 422)
    
    conn =
      put(conn, Routes.main_path(conn, :draw, ascii_canvas.hash), %{
        x: 0,
        width: 8,
        height: 8,
        outline: "S"
      })
    
    assert _body = json_response(conn, 422)
  end
end
