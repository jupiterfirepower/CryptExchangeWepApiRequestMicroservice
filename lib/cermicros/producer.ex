defmodule Cermicros.Producer do
  @moduledoc """
  Cermicros.Producer
  """
  use GenStage
  require Logger
  alias Cermicros.UriHelper

  def start_link(_args) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    Logger.info("PageProducer init.")
    {:producer, state}
  end

  def do_work(url_list) when is_list(url_list) do
    #domain_list = Enum.uniq(Enum.map(url_list, fn(x) -> domain.(x) end))
    #result = for d <- domain_list, do: {d, Enum.uniq(Enum.filter(url_list, fn(x) -> domain.(x) == d end))}

    result = Enum.group_by(url_list, & UriHelper.get_domain(&1)) |> Enum.into([])

    GenStage.cast(__MODULE__, {:urls, result})
  end

  def handle_cast({:urls, url_list}, state) do
    {:noreply, url_list, state}
  end

  def handle_demand(demand, state) do
    Logger.info("PageProducer received demand for #{demand} pages.")
    {:noreply, [], state}
  end
end
