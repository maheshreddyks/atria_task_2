defmodule AtriaTask2Web.Router do
  use AtriaTask2Web, :router

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

  scope "/", AtriaTask2Web do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", AtriaTask2Web do
    pipe_through([:api])

    post("/:type/signup", UserController, :signup)

    get("/:type/event/list", EventController, :list_events)
    post("/:type/event/add", EventController, :admin_add_event)
    post("/:type/event/add/:id", EventController, :user_add_event)
    post("/admin/event/update/:id", EventController, :admin_update_event)
    delete("/admin/event/delete/:id", EventController, :admin_delete_event)
    delete("/v1/event/delete/:id", EventController, :user_delete_event)

    get("/:type/event/list/:event_type", EventController, :user_filter_events)
    get("/:type/event_calender", EventController, :event_calender)
  end

  # Other scopes may use custom stacks.
  # scope "/api", AtriaTask2Web do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AtriaTask2Web.Telemetry
    end
  end
end
