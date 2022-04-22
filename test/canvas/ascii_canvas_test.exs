defmodule Canvas.ASCIICanvasTest do
  use ExUnit.Case
  alias Canvas.ASCIICanvas
  @width 30
  @height 30

  setup do
    ascii_canvas = ASCIICanvas.init(@height, @width)

    {:ok, ascii_canvas: ascii_canvas}
  end

  test "should initialize a canvas with correct dimensions" do
    width = 10
    height = 5

    assert %ASCIICanvas{canvas: canvas, width: ^width, height: ^height} =
             ASCIICanvas.init(height, width)

    assert Map.get(canvas, {0, 0}) == ?\s
    assert Map.get(canvas, {3, 3}) == ?\s
    assert Map.get(canvas, {width - 1, height - 1}) == ?\s

    # overflow
    assert Map.get(canvas, {width, 0}) == nil
  end

  test "should not accept empty fill and outline for drawing operation",
       %{ascii_canvas: ascii_canvas} do
    assert {:error, :fill_and_outline_empty} =
             ASCIICanvas.draw(ascii_canvas, x: 5, y: 5, width: 5, height: 5)
  end

  test "should not accept overflow drawing operation",
       %{ascii_canvas: ascii_canvas} do
    assert {:error, :overflow} =
             ASCIICanvas.draw(ascii_canvas,
               x: @height - 5,
               y: @width - 5,
               width: 6,
               height: 5,
               fill: ?C
             )

    assert {:error, :overflow} =
             ASCIICanvas.draw(ascii_canvas,
               x: @height - 5,
               y: @width - 5,
               width: 5,
               height: 6,
               fill: ?C
             )

    # this fits
    assert {:ok, ascii_canvas} =
             ASCIICanvas.draw(ascii_canvas,
               x: @height - 5,
               y: @width - 5,
               width: 5,
               height: 5,
               fill: ?C
             )
  end

  test "should draw an outline", %{ascii_canvas: ascii_canvas} do
    assert {:ok, ascii_canvas} =
             ASCIICanvas.draw(ascii_canvas,
               x: 0,
               y: 0,
               width: 7,
               height: 7,
               outline: ?C
             )

    # checking edges and the middle
    assert ascii_canvas.canvas[{0, 0}] == ?C
    assert ascii_canvas.canvas[{3, 6}] == ?C
    assert ascii_canvas.canvas[{6, 6}] == ?C
    assert ascii_canvas.canvas[{6, 3}] == ?C
    assert ascii_canvas.canvas[{3, 3}] == ?\s
  end
  
  
  test "should fill a rectangle", %{ascii_canvas: ascii_canvas} do
    assert {:ok, ascii_canvas} =
             ASCIICanvas.draw(ascii_canvas,
               x: @width - 8,
               y: @height - 8,
               width: 8,
               height: 8,
               fill: ?X
             )

    # checking edges and the middle
    assert ascii_canvas.canvas[{@width - 1, @height - 1}] == ?X
    assert ascii_canvas.canvas[{@width - 8, @height - 8}] == ?X
    assert ascii_canvas.canvas[{@width - 9, @height - 8}] == ?\s
  end
  
  test "should fill and outline a rectangle", %{ascii_canvas: ascii_canvas} do
    assert {:ok, ascii_canvas} =
             ASCIICanvas.draw(ascii_canvas,
               x: 0,
               y: @height - 8,
               width: 8,
               height: 8,
               fill: ?X,
               outline: ?C
             )

    # checking edges and the middle
    assert ascii_canvas.canvas[{0, @height - 1}] == ?C
    assert ascii_canvas.canvas[{7, @height - 8}] == ?C
    assert ascii_canvas.canvas[{5, @height - 5}] == ?X
    assert ascii_canvas.canvas[{@width - 9, @height - 8}] == ?\s
  end

  test "should render", %{ascii_canvas: ascii_canvas} do
    assert {:ok, ascii_canvas} =
             ASCIICanvas.draw(ascii_canvas,
               x: 0,
               y: 0,
               width: 2,
               height: 4,
               fill: ?X,
               outline: ?C
             )
    str = ASCIICanvas.render(ascii_canvas) 
    assert is_binary(str) == true
    assert String.at(str, 0) == "C"
    assert String.at(str, @width) == "\n"
    assert String.at(str, @width + 2) == "X"
  end
end
