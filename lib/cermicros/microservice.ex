defmodule Cermicros.Microservice do
  @moduledoc """
  Cermicros.Microservice
  """
  import Plug.Conn
  use Plug.Router
  require Logger

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  defp get_sys_state() do
    pid_cache = Process.whereis(Cermicros.Cache)
    pid_taskmanager = Process.whereis(Cermicros.TaskManager)
    pid_producer = Process.whereis(Cermicros.Producer)

    {islive_cache?, cache_status} = get_process_state(pid_cache)
    {islive_taskmanager?, tm_status} = get_process_state(pid_taskmanager)
    {islive_producer?, producer_status} = get_process_state(pid_producer)
    {islive_microservice?, microservice_status} = get_process_state(self())

    %{
      "service status" => "ok",
      "cache" => "live: #{islive_cache?}, status: #{inspect(cache_status)}",
      "taskmanager" => "live: #{islive_taskmanager?}, status: #{inspect(tm_status)}",
      "producer" => "live: #{islive_producer?}, status: #{inspect(producer_status)}",
      "microservice" => "live: #{islive_microservice?}, status: #{inspect(microservice_status)}",
      "supervisors" => "live: ok",
    }
  end

  defp get_process_state(pid) do
    islive_process? = Process.alive?(pid)
    {_, process_status} = Process.info(pid) |> Enum.at(3)
    {islive_process? , process_status}
  end

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: :ok}))
  end

  get "/health" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(get_sys_state()))
  end

  #get("/health", do: send_resp(conn, 200, Jason.encode!(get_sys_state())))

  use Plug.ErrorHandler

  defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    type = Plug.Conn.Status.reason_atom(conn.status)
    message = Plug.Conn.Status.reason_phrase(conn.status)
    respond(conn, {conn.status, %{message: message, code: conn.status, type: type}})
  end

  defp respond(conn, {:error, status_code}) do
    code = Plug.Conn.Status.code(status_code)
    type = Plug.Conn.Status.reason_atom(code)
    message = Plug.Conn.Status.reason_phrase(code)
    respond(conn, {status_code, %{code: code, type: type, message: message}})
  end

  defp respond(conn, {status_code, data}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status_code, Jason.encode!(data))
  end

  def start_link do
    Plug.Cowboy.http(Cermicros.Microservice, [plug: Cermicros.Microservice, scheme: :http, options: [port: 4000]], [])
    #webserver = {Plug.Cowboy, plug: CryptExchangeDataProviderMicroservice, scheme: :http, options: [port: 4000]}
    Logger.info("Plug now running on localhost:4000")
    Process.sleep(:infinity)
  end

  @impl true
  def init(state) do
    Logger.info("Cermicros.Microservice init.")

    {:ok, state}
  end
end
