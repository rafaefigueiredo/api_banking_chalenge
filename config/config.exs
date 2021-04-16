import Config

config :api_banking_chalenge,
  ecto_repos: [ApiBankingChalenge.Repo]

config :api_banking_chalenge_web,
  ecto_repos: [ApiBankingChalenge.Repo],
  generators: [context_app: :api_banking_chalenge, binary_id: true]

config :api_banking_chalenge_web, ApiBankingChalengeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FM/b8P3D2LmjWW5TGAm87GVksRGUqb4+4IwcEYjyxLC9xXJ1izLnOF7/SZWMGhdt",
  render_errors: [view: ApiBankingChalengeWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ApiBankingChalenge.PubSub,
  live_view: [signing_salt: "HLpmthbU"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
