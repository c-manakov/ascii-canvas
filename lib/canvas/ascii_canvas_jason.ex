defimpl Jason.Encoder, for: Canvas.ASCIICanvas do
  def encode(value, opts) do
    canvas =
      value.canvas
      |> Map.to_list()
      |> Enum.map(fn {coords, v} -> {Canvas.ASCIICanvas.coords_to_string(coords), v} end)
      |> Enum.into(%{})

    value = Map.put(value, :canvas, canvas)

    Jason.Encode.map(value, opts)
  end
end
