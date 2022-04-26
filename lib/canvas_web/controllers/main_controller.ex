defmodule CanvasWeb.MainController do
  use CanvasWeb, :controller

  alias Canvas.Canvases

  action_fallback CanvasWeb.FallbackController

  def create(conn, %{"height" => height, "width" => width}) do
    {:ok, canvas_record} = Canvases.create_ascii_canvas(height, width)
    render(conn, "create.json", canvas: canvas_record)
  end

  def show(conn, %{"hash" => hash}) do
    with {:ok, canvas} <- Canvases.fetch_ascii_canvas_by_hash(hash) do
      render(conn, "show.json", canvas: canvas)
    end
  end
end
