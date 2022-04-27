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

  @draw_body %{
    width: [type: :integer, required: true],
    height: [type: :integer, required: true],
    x: [type: :integer, required: true],
    y: [type: :integer, required: true],
    outline: [type: :integer, cast_func: {__MODULE__, :str_to_char}],
    fill: [type: :integer, cast_func: {__MODULE__, :str_to_char}]
  }
  def str_to_char(nil, _), do: {:ok, nil}
  def str_to_char("", _), do: {:ok, nil}
  def str_to_char(str, _), do: {:ok, hd(String.to_charlist(str))}
  
  def draw(conn, %{"hash" => hash}) do
    body = conn.body_params

    with {:ok, body} <- Tarams.cast(body, @draw_body),
         opts = Map.to_list(body),
         {:ok, canvas} <- Canvases.fetch_ascii_canvas_by_hash(hash),
         {:ok, canvas} <- Canvases.draw(canvas, opts) do
      render(conn, "draw.json", canvas: canvas)
    end
  end

end
