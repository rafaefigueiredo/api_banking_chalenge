import Config

config :api_banking_chalenge_web, ApiBankingChalengeWeb.Endpoint,
  url: [host: "example.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info
