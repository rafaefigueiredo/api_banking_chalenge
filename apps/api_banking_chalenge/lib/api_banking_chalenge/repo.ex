defmodule ApiBankingChalenge.Repo do
  use Ecto.Repo,
    otp_app: :api_banking_chalenge,
    adapter: Ecto.Adapters.Postgres
end
