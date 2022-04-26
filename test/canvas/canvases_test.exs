defmodule Canvas.CanvasesTest do
  use Canvas.DataCase

  alias Canvas.Canvases
  alias Canvas.ASCIICanvas

  @width 10
  @height 10
  describe "ascii_canvases" do
    alias Canvas.Canvases.AsciiCanvasRecord

    import Canvas.CanvasesFixtures

    test "get_ascii_canvas!/1 returns the ascii_canvas with given id" do
      ascii_canvas = ascii_canvas_fixture()
      assert Canvases.get_ascii_canvas!(ascii_canvas.id) == ascii_canvas
    end

    test "create_ascii_canvas/1 should create and save a new canvas" do
      assert {:ok, %AsciiCanvasRecord{} = ascii_canvas} =
               Canvases.create_ascii_canvas(@width, @height)

      assert %ASCIICanvas{} = canvas = ascii_canvas.data

      assert canvas.width == @width
      assert canvas.height == @height
    end

    test "get_ascii_canvas_by_hash/1 should get a canvas" do
      ascii_canvas = ascii_canvas_fixture()

      {:ok, fetched_canvas} = Canvases.fetch_ascii_canvas_by_hash(ascii_canvas.hash)

      assert ascii_canvas == fetched_canvas
    end
  end
end
