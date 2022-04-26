defmodule CanvasWeb.MainController do
  use CanvasWeb, :controller

  alias Canvas.Canvases

  def create(conn, %{"height" => height, "width" => width}) do
    {:ok, canvas_record} = Canvases.create_ascii_canvas(height, width)
    render(conn, "create.json", canvas: canvas_record)
  end
end
