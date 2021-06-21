defmodule ApiBankingChalenge.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      ApiBankingChalenge.Repo,
      {Phoenix.PubSub, name: ApiBankingChalenge.PubSub}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: ApiBankingChalenge.Supervisor)
  end
end
