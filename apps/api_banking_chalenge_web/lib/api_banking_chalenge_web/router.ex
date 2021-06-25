defmodule ApiBankingChalengeWeb.Router do
  use ApiBankingChalengeWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", ApiBankingChalengeWeb do
    pipe_through(:api)

    # accounts
    post("/accounts", AccountsController, :create)
    get("/accounts/:id", AccountsController, :show)
    delete("/accounts/:id", AccountsController, :delete)

    # transactions
    post("/transactions", TransactionsController, :transaction)
    post("/transactions", TransactionsController, :withdraw)
    post("/transactions", TransactionsController, :deposit)
  end
end
