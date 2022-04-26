defmodule CanvasWeb.MainView do
  use CanvasWeb, :view

  def render("create.json", %{canvas: canvas}) do
    %{hash: canvas.hash, id: canvas.id, data: Jason.encode!(canvas.data)}
  end
  
  def render("show.json", %{canvas: canvas}) do
    %{hash: canvas.hash, id: canvas.id, data: Jason.encode!(canvas.data)}
  end
end
