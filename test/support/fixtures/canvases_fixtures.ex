defmodule Canvas.CanvasesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Canvas.Canvases` context.
  """

  @doc """
  Generate a ascii_canvas.
  """
  def ascii_canvas_fixture(width \\ 10, height \\ 10) do
    {:ok, ascii_canvas} = Canvas.Canvases.create_ascii_canvas(width, height)

    ascii_canvas
  end
end
