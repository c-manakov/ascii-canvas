defmodule CanvasWeb.MainView do
  use CanvasWeb, :view

  def render("create.json", %{canvas: canvas}) do
    render_canvas(canvas)
  end
  
  def render("show.json", %{canvas: canvas}) do
    render_canvas(canvas)
  end
  
  def render("draw.json", %{canvas: canvas}) do
    render_canvas(canvas)
  end

  defp render_canvas(canvas) do
    %{hash: canvas.hash, id: canvas.id, data: Jason.encode!(canvas.data)}
  end
end
