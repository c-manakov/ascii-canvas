defmodule CanvasWeb.Router do
  use CanvasWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CanvasWeb do
    pipe_through :api
  end

  post "/canvas", CanvasWeb.MainController, :create
  get "/canvas/:hash", CanvasWeb.MainController, :show
  put "/canvas/:hash/draw", CanvasWeb.MainController, :draw
end
