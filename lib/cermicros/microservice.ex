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

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{test: :ok}))
  end

  get("/ping", do: send_resp(conn, 200, Jason.encode!("pong")))

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
    #{:ok, _} = Supervisor.start_link([webserver], strategy: :one_for_one)
    Logger.info("Plug now running on localhost:4000")
    Process.sleep(:infinity)
  end

  @impl true
  def init(state) do
    Logger.info("Cermicros.Microservice init.")

    {:ok, state}
  end
end
