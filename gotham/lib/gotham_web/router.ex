defmodule GothamWeb.Router do
  use GothamWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GothamWeb do
    pipe_through :api

    scope "/users" do
      # post "/", UserController, :create
      # get "/:userID/teams", UserController, :get_team_of_manager

      get "/", UserController, :get_user_by_query_params
      get "/:userID", UserController, :show 
      put "/:userID", UserController, :update
      delete "/:userID", UserController, :delete
      post "/sign_up", UserController, :signup
      post "/sign_in", UserController, :signin
      post "/sign_out", UserController, :logout
    end

    scope "/workingtimes" do
      get "/:userID", WorkingtimeController, :get_multiple_working_time
      # get "/:userID/:id", WorkingtimeController, :get_one_working_time
      post "/:userID", WorkingtimeController, :add_user_working_time 
      put "/:id", WorkingtimeController, :update 
      delete "/:id", WorkingtimeController, :delete
    end

    scope "/clocks" do
      get "/:userID", ClockController, :show 
      post "/:userID", ClockController, :add_user_clock
    end

    scope "/teams" do
      post "/", TeamController, :create 
      get "/", TeamController, :index 
      get "/:teamID", TeamController, :show
      delete "/:teamID", TeamController, :delete
      put "/:teamID/users/:userID", TeamController, :add_user_to_team
      delete "/:teamID/users/:userID", TeamController, :delete_user_team 
      put "/:teamID", TeamController, :update 
      get "/:teamID/users", TeamController, :list_users_of_team
      get "/users/:userID", TeamController, :get_team_of_manager
      # get "/:teamID/workingtimes", TeamController, :get_workingtimes_of_team # utilisé ? 
    end
  end

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
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: GothamWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
