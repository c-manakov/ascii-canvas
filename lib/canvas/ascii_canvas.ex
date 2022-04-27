defmodule Canvas.ASCIICanvas do
  alias __MODULE__

  defstruct [:canvas, :width, :height]

  def init(height, width) do
    canvas =
      for i <- 0..(width - 1),
          j <- 0..(height - 1),
          into: %{},
          do: {{i, j}, ?\s}

    %ASCIICanvas{canvas: canvas, width: width, height: height}
  end

  def draw(canvas, opts \\ []) do
    with {:ok, x} <- Keyword.fetch(opts, :x),
         {:ok, y} <- Keyword.fetch(opts, :y),
         {:ok, width} <- Keyword.fetch(opts, :width),
         {:ok, height} <- Keyword.fetch(opts, :height),
         fill = Keyword.get(opts, :fill, nil),
         outline = Keyword.get(opts, :outline, nil) do
      cond do
        fill == nil and outline == nil ->
          {:error, :fill_and_outline_empty}

        x + height > canvas.height or y + width > canvas.width ->
          {:error, :overflow}

        true ->
          canvas_map = draw(canvas.canvas, x, y, width, height, fill, outline)
          {:ok, %ASCIICanvas{canvas: canvas_map, width: canvas.width, height: canvas.height}}
      end
    end
  end

  defp draw(canvas, x, y, width, height, fill, outline) do
    canvas = if outline != nil, do: outline(canvas, x, y, width, height, outline), else: canvas

    # fill the inner rectangle if outline is also present
    canvas =
      if outline != nil and fill != nil,
        do: fill(canvas, x + 1, y + 1, width - 2, height - 2, fill),
        else: canvas

    canvas =
      if outline == nil and fill != nil,
        do: fill(canvas, x, y, width, height, fill),
        else: canvas

    canvas
  end

  defp outline(canvas, x, y, width, height, outline) do
    top_edge = for i <- x..(x + width - 1), into: %{}, do: {{i, y}, outline}
    bottom_edge = for i <- x..(x + width - 1), into: %{}, do: {{i, y + height - 1}, outline}

    left_edge = for j <- y..(y + height - 1), into: %{}, do: {{x, j}, outline}
    right_edge = for j <- y..(y + height - 1), into: %{}, do: {{x + width - 1, j}, outline}

    canvas
    |> Map.merge(top_edge)
    |> Map.merge(bottom_edge)
    |> Map.merge(left_edge)
    |> Map.merge(right_edge)
  end

  defp fill(canvas, x, y, width, height, fill) do
    rectangle =
      for i <- x..(x + width - 1),
          j <- y..(y + height - 1),
          into: %{},
          do: {{i, j}, fill}

    Map.merge(canvas, rectangle)
  end

  def render(%ASCIICanvas{canvas: canvas, width: width, height: height}) do
    charlist =
      for j <- 0..(height - 1),
          i <- 0..width,
          do: render_character(canvas, width, height, i, j)

    List.to_string(charlist)
  end

  # render newlines at the end of each line except for the last one
  defp render_character(_canvas, width, height, i, j) when i == width and j == height - 1, do: []
  defp render_character(_canvas, width, _height, i, _j) when i == width, do: ?\n
  defp render_character(canvas, _width, _height, i, j), do: canvas[{i, j}]

  def coords_to_string({i, j}), do: "#{i},#{j}"

  def string_to_coords(str) do
    [i, j] = String.split(str, ",") |> Enum.map(&String.to_integer/1)
    {i, j}
  end
end
