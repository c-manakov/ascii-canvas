defmodule Canvas.Canvases.AsciiCanvasRecord do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ascii_canvases" do
    field :data, Canvas.EctoCanvas
    field :hash, :string

    timestamps()
  end

  @doc false
  def changeset(ascii_canvas, attrs) do
    ascii_canvas
    |> cast(attrs, [:hash, :data])
    |> validate_required([:hash, :data])
  end
end
