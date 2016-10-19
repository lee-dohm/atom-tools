defmodule AtomTools.Router do
  use AtomTools.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AtomTools do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/version", VersionController, :index
    post "/version/verify", VersionController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", AtomTools do
  #   pipe_through :api
  # end
end
