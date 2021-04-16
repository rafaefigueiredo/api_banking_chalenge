defmodule ApiBankingChalenge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ApiBankingChalenge.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ApiBankingChalenge.PubSub}
      # Start a worker by calling: ApiBankingChalenge.Worker.start_link(arg)
      # {ApiBankingChalenge.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: ApiBankingChalenge.Supervisor)
  end
end
