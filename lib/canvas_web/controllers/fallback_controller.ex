defmodule CanvasWeb.FallbackController do
  use CanvasWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> json(%{"message" => "Not Found"})
  end

  def call(conn, {:error, :overflow}) do
    conn
    |> put_status(422)
    |> json(%{"message" => "Overflow"})
  end

  def call(conn, {:error, :fill_and_outline_empty}) do
    conn
    |> put_status(422)
    |> json(%{"message" => "Fill and outline empty"})
  end

  def call(conn, {:error, data}) do
    conn
    |> put_status(422)
    |> json(%{"message" => "Unprocessable entity", data: data})
  end
end
