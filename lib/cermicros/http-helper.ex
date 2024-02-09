defmodule Cermicros.HttpHelper do
  @moduledoc """
  Helper
  """
  import Cermicros.RetryHelper
  alias Cermicros.RetryHelper, as: PoisonRetryHelper
  alias Cermicros.UriHelper

  defp cyan_text(text) do
    IO.ANSI.cyan() <> text <> IO.ANSI.reset()
  end

  def domain(url) do
    URI.parse(url).host
    |> String.split(".")
    |> Enum.take(-2)
    |> Enum.join(".")
  end

  def check_if_gzipped(headers) do
    Enum.any?(headers, fn (k) ->
      case k do
        {"Content-Encoding", "gzip"} -> true
        {"content-encoding", "gzip"} -> true
        {"Content-Encoding", "x-gzip"} -> true
        {"content-encoding", "x-gzip"} -> true
        _ -> false
      end
    end)
  end

  def unzip_body(true, body), do: :zlib.gunzip(body)

  def unzip_body(false, body), do: body

  def gzip_data(data), do: :zlib.gzip(data)

  def gunzip_data(data), do: :zlib.gunzip(data)

  def http_request_retry(url, headers) do
      HTTPoison.get(url, headers)
      |> PoisonRetryHelper.autoretry(max_attempts: 3, wait: 0, include_404s: false, retry_unknown_errors: true)
  end

  def call_apis_async(url_list) do
    headers = [
      {"Accept-Encoding", "gzip"}, {"Content-Type", "application/json"}
    ]
    max_concurrency = System.schedulers_online * 2
    time_start = System.monotonic_time(:millisecond)
    responses = url_list
                |> Task.async_stream(&http_request_retry(&1, headers), max_concurrency: max_concurrency, ordered: false)
                #|> Task.async_stream(&HTTPoison.get(&1,headers), max_concurrency: max_concurrency, ordered: false)
                |> Enum.into([], fn {:ok, res} -> res end)


    json_data =
      Enum.map(responses, fn
      {:ok, %HTTPoison.Response{status_code: 200, headers: resp_headers, body: body, request_url: url}} ->

        json = resp_headers
               |> check_if_gzipped
               |> unzip_body(body)

        {:ok, url, json}

      {:ok,  %HTTPoison.Response{status_code: status_code }} -> {:error, status_code}
      {:error, error} -> {:error, error}
    end)

    time_end = System.monotonic_time(:millisecond)
    seconds = (time_end - time_start) / 1000
    cyan_text("time #{seconds}s, domain: #{UriHelper.get_domain(hd(url_list))}, url count: #{length(url_list)}") |> IO.puts()

    filtered = Enum.filter(json_data, & tuple_size(&1) == 3)
    ex_data = Enum.map(filtered, fn ({_, u, d}) -> %{:url => u, :data => d} end)
    current = %{:wm => "watermark", :dt =>  gzip_data(Jason.encode!(ex_data))}

    current
  end
end
