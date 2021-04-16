import Config

config :api_banking_chalenge, ApiBankingChalenge.Repo,
  username: "postgres",
  password: "postgres",
  database: "api_banking_chalenge_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :api_banking_chalenge_web, ApiBankingChalengeWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
