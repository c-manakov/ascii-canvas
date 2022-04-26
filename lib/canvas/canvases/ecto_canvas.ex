defmodule Canvas.EctoCanvas do
  use Ecto.Type
  alias Canvas.ASCIICanvas
  def type, do: :map

  # Provide custom casting rules.
  # Cast strings into the URI struct to be used at runtime
  def cast(%ASCIICanvas{} = canvas) do
    {:ok, canvas}
  end

  # Everything else is a failure though
  def cast(_), do: :error

  # When loading data from the database, as long as it's a map,
  # we just put the data back into a URI struct to be stored in
  # the loaded schema struct.
  def load(data) do
    canvas_map =
      for {key, val} <- data["canvas"], into: %{}, do: {ASCIICanvas.string_to_coords(key), val}

    data = Map.put(data, "canvas", canvas_map)

    {:ok, %ASCIICanvas{canvas: canvas_map, height: data["height"], width: data["width"]}}
  end

  # When dumping data to the database, we *expect* a URI struct
  # but any value could be inserted into the schema struct at runtime,
  # so we need to guard against them.
  def dump(%ASCIICanvas{} = canvas), do: {:ok, canvas}
  def dump(_), do: :error
end
