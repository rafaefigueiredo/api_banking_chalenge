defmodule ApiBankingChalengeWeb.Router do
  use ApiBankingChalengeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiBankingChalengeWeb do
    pipe_through :api

    get "/posts", PostsController, :list
    post "posts", PostsController, :create
    get "/posts/:id", PostsController, :show
  end
end
