defmodule Canvas.CanvasesTest do
  use Canvas.DataCase

  alias Canvas.Canvases
  alias Canvas.ASCIICanvas

  @width 10
  @height 10
  describe "ascii_canvases" do
    alias Canvas.Canvases.AsciiCanvasRecord

    import Canvas.CanvasesFixtures

    test "get_ascii_canvas!/1 returns the ascii_canvas_record with given id" do
      ascii_canvas_record = ascii_canvas_fixture()
      assert Canvases.get_ascii_canvas!(ascii_canvas_record.id) == ascii_canvas_record
    end

    test "create_ascii_canvas/1 should create and save a new canvas" do
      assert {:ok, %AsciiCanvasRecord{} = ascii_canvas_record} =
               Canvases.create_ascii_canvas(@width, @height)

      assert %ASCIICanvas{} = canvas = ascii_canvas_record.data

      assert canvas.width == @width
      assert canvas.height == @height
    end

    test "get_ascii_canvas_by_hash/1 should get a canvas" do
      ascii_canvas_record = ascii_canvas_fixture()

      {:ok, fetched_canvas} = Canvases.fetch_ascii_canvas_by_hash(ascii_canvas_record.hash)

      assert ascii_canvas_record == fetched_canvas
    end

    test "get_ascii_canvas_by_hash/1 should return an error if there's no canvas" do
      assert {:error, :not_found} = Canvases.fetch_ascii_canvas_by_hash("some-hash")
    end

    test "draw/2 should draw on a canvas" do
      ascii_canvas_record = ascii_canvas_fixture()

      assert {:ok, ascii_canvas_record} =
               Canvases.draw(ascii_canvas_record,
                 x: 0,
                 y: 0,
                 width: 8,
                 height: 8,
                 fill: ?X,
                 outline: ?C
               )

      ascii_canvas = ascii_canvas_record.data
      assert ascii_canvas.canvas[{2, 2}] == ?X

      # making sure it updated in the db
      {:ok, fetched_canvas_record} = Canvases.fetch_ascii_canvas_by_hash(ascii_canvas_record.hash)

      assert fetched_canvas_record == ascii_canvas_record
    end

    test "draw/2 should return an error" do
      ascii_canvas_record = ascii_canvas_fixture()

      assert {:error, :overflow} =
               Canvases.draw(ascii_canvas_record,
                 x: 0,
                 y: 8,
                 width: 8,
                 height: 8,
                 fill: ?X,
                 outline: ?C
               )
    end
  end
end
