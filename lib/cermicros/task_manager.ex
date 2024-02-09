defmodule Cermicros.TaskManager do
  use GenServer
  require Logger
  alias Cermicros.HttpHelper, as: HttpHelper
  alias Cermicros.Cache

  @moduledoc """
  Documentation for `Cermicros.TaskManager`.
  """

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    Logger.info("TaskManager init.")
    Logger.info("Init scheduling: run schedule_work().")
    schedule_work()

    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    spawn_link(&do_work/0)
    schedule_work()

    {:noreply, state}
  end

  defp do_work() do
    urls = Jason.decode!(HttpHelper.gunzip_data((Cache.get "uri")))
    Cermicros.Producer.do_work(urls)
  end

  defp schedule_work do
    # We schedule the work to happen in 1 minutes(writing in seconds).
    Process.send_after(self(), :work, :timer.seconds(60))
  end

end
