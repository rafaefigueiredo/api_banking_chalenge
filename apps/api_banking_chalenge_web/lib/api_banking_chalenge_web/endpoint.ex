defmodule ApiBankingChalengeWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :api_banking_chalenge_web

  @session_options [
    store: :cookie,
    key: "_api_banking_chalenge_web_key",
    signing_salt: "P38vD2sH"
  ]

  socket "/socket", ApiBankingChalengeWeb.UserSocket,
    websocket: true,
    longpoll: false

  plug Plug.Static,
    at: "/",
    from: :api_banking_chalenge_web,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :api_banking_chalenge_web
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug ApiBankingChalengeWeb.Router
end
