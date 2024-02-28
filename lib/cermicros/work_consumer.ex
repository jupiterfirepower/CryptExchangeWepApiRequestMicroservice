defmodule Cermicros.WorkConsumer do
  @moduledoc """
  Cermicros.WorkConsumer
  """

  alias Cermicros.HttpHelper, as: ApiHelper
  require Logger

  defp cyan_text(text) do
    IO.ANSI.cyan() <> text <> IO.ANSI.reset()
  end

  def start_link(event) do
    {domain, list} = event
    #Logger.info("#{inspect(self())} WorkConsumer received domain: #{domain}, urls count: #{length(list)}")

    Task.start_link(fn ->
      Logger.info("#{inspect(self())} WorkConsumer received domain: #{domain}, urls count: #{length(list)}")
      data = ApiHelper.call_apis_async(list)
      # send to kafka.
      time_start = System.monotonic_time(:millisecond)
      send_message("exchange_topic", data)
      time_end = System.monotonic_time(:millisecond)
      seconds = (time_end - time_start) / 1000
      cyan_text("time #{seconds}s, send_message to kafka topic: exchange_topic") |> IO.puts()
    end)

  end

  defp send_message(key, value) do
    Kaffe.Producer.produce_sync(key, value)
  end
end
