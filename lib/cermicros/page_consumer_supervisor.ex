defmodule Cermicros.PageConsumerSupervisor do
  @moduledoc """
  Cermicros.PageConsumerSupervisor
  """
  use ConsumerSupervisor
  require Logger

  def start_link(_args) do
    ConsumerSupervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do

    Logger.info("Cermicros.PageConsumerSupervisor init.")

    children = [
       %{id: Cermicros.WorkConsumer,
         start: {Cermicros.WorkConsumer, :start_link, []},
         restart: :transient
        }
    ]

    opts = [
      strategy: :one_for_one,
      subscribe_to: [{Cermicros.Producer, max_demand: 500}]
    ]

    ConsumerSupervisor.init(children, opts)
  end
end
