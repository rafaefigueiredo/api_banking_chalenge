defmodule ApiBankingChalengeWeb.Router do
  use ApiBankingChalengeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiBankingChalengeWeb do
    pipe_through :api
  end
end
