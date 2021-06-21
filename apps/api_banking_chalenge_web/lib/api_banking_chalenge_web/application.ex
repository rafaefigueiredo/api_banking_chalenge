defmodule ApiBankingChalengeWeb.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      ApiBankingChalengeWeb.Telemetry,
      ApiBankingChalengeWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: ApiBankingChalengeWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ApiBankingChalengeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
