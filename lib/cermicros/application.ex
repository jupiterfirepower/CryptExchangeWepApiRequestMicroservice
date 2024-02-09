defmodule Cermicros.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger


  @impl true
  def start(_type, _args) do
    children = [
      Cermicros.Cache,
      {Cermicros.TaskManager, []},
      {Cermicros.Producer, []},
      {Cermicros.PageConsumerSupervisor, []},
      %{
        id: Cermicros.Microservice,
        start: {Cermicros.Microservice, :start_link, []}
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cermicros.Supervisor]
    Supervisor.start_link(children, opts)

  end
end
