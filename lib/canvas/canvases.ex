defmodule Canvas.Canvases do
  @moduledoc """
  The Canvases context.
  """

  import Ecto.Query, warn: false
  alias Canvas.Repo

  alias Canvas.Canvases.AsciiCanvasRecord
  alias Canvas.ASCIICanvas

  @doc """
  Returns the list of ascii_canvases.

  ## Examples

      iex> list_ascii_canvases()
      [%AsciiCanvasRecord{}, ...]

  """
  def list_ascii_canvases do
    Repo.all(AsciiCanvasRecord)
  end

  @doc """
  Gets a single ascii_canvas.

  Raises `Ecto.NoResultsError` if the Ascii canvas does not exist.

  ## Examples

      iex> get_ascii_canvas!(123)
      %AsciiCanvasRecord{}

      iex> get_ascii_canvas!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ascii_canvas!(id), do: Repo.get!(AsciiCanvasRecord, id)
  
  @doc """
  ## Examples

      iex> fetch_ascii_canvas_by_hash("1234")
      {:ok, %AsciiCanvasRecord{}}

      iex> fetch_ascii_canvas_by_hash("214")
      {:error, :not_found}
  """
  def fetch_ascii_canvas_by_hash(hash) do
    case Repo.get_by(AsciiCanvasRecord, hash: hash) do
      nil -> {:error, :not_found}
      canvas -> 
        IO.puts(ASCIICanvas.render(canvas.data))
        {:ok, canvas}
    end
  end

  @doc """
  Creates a ascii_canvas.

  ## Examples

      iex> create_ascii_canvas(%{field: value})
      {:ok, %AsciiCanvasRecord{}}

      iex> create_ascii_canvas(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ascii_canvas(width, height) do
    ascii_canvas = ASCIICanvas.init(width, height)

    hash = random_hash()

    Repo.insert(%AsciiCanvasRecord{data: ascii_canvas, hash: hash})
  end

  def draw(%AsciiCanvasRecord{} = canvas, opts) do
    ascii_canvas = canvas.data

    with {:ok, ascii_canvas} <- ASCIICanvas.draw(ascii_canvas, opts) do
      canvas
      |> Ecto.Changeset.change(data: ascii_canvas)
      |> Repo.update()
    end
  end

  defp random_hash() do
    hash = :crypto.strong_rand_bytes(6) |> Base.url_encode64()

    case fetch_ascii_canvas_by_hash(hash) do
      {:error, :not_found} -> hash
      {:ok, _} -> random_hash()
    end
  end
end
