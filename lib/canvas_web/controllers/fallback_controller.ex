defmodule CanvasWeb.FallbackController do
  use CanvasWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> json(%{"message" => "Not Found"})
  end
end
