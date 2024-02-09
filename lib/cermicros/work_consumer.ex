defmodule Cermicros.WorkConsumer do
  @moduledoc """
  Cermicros.WorkConsumer
  """

  alias Cermicros.HttpHelper, as: ApiHelper
  require Logger

  def start_link(event) do
    {domain, list} = event
    #Logger.info("#{inspect(self())} WorkConsumer received domain: #{domain}, urls count: #{length(list)}")

    Task.start_link(fn ->
      Logger.info("#{inspect(self())} WorkConsumer received domain: #{domain}, urls count: #{length(list)}")
      data = ApiHelper.call_apis_async(list)
      # send to kafka.
      send_message("exchange_topic", data)
    end)

  end

  defp send_message(key, value) do
    Kaffe.Producer.produce_sync(key, value)
  end
end
