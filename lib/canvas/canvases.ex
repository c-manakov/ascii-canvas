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

  def get_ascii_canvas_by_hash(hash), do: Repo.get_by(AsciiCanvasRecord, hash: hash)

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

  defp random_hash() do
    hash = :crypto.strong_rand_bytes(6) |> Base.url_encode64 

    case get_ascii_canvas_by_hash(hash) do
      nil -> hash
      _ -> random_hash()
    end
  end

  @doc """
  Updates a ascii_canvas.

  ## Examples

      iex> update_ascii_canvas(ascii_canvas, %{field: new_value})
      {:ok, %AsciiCanvasRecord{}}

      iex> update_ascii_canvas(ascii_canvas, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ascii_canvas(%AsciiCanvasRecord{} = ascii_canvas, attrs) do
    ascii_canvas
    |> AsciiCanvasRecord.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ascii_canvas.

  ## Examples

      iex> delete_ascii_canvas(ascii_canvas)
      {:ok, %AsciiCanvasRecord{}}

      iex> delete_ascii_canvas(ascii_canvas)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ascii_canvas(%AsciiCanvasRecord{} = ascii_canvas) do
    Repo.delete(ascii_canvas)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ascii_canvas changes.

  ## Examples

      iex> change_ascii_canvas(ascii_canvas)
      %Ecto.Changeset{data: %AsciiCanvasRecord{}}

  """
  def change_ascii_canvas(%AsciiCanvasRecord{} = ascii_canvas, attrs \\ %{}) do
    AsciiCanvasRecord.changeset(ascii_canvas, attrs)
  end
end
