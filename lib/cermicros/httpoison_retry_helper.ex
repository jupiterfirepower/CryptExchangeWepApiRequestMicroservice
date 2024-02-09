defmodule Cermicros.RetryHelper do
  @moduledoc """
  HttpRequest.Helper
  """
  @max_attempts 3
  @reattempt_wait 0

  defmacro autoretry(attempt, opts \\ []) do
    quote location: :keep, generated: true do
      attempt_fn = fn -> unquote(attempt) end
      opts = get_merged_opts(unquote(opts))
      get_response_with_error_handling(attempt_fn, opts)
    end
  end

  def get_merged_opts(opts) do
    Keyword.merge([
      max_attempts: Application.get_env(:httpoison_retry, :max_attempts) || @max_attempts,
      wait: Application.get_env(:httpoison_retry, :wait) || @reattempt_wait,
      include_404s: Application.get_env(:httpoison_retry, :include_404s) || false,
      retry_unknown_errors: Application.get_env(:httpoison_retry, :retry_unknown_errors) || false,
      attempt: 1
    ], opts)
  end

  def get_response_with_error_handling(attempt_fn, opts) do
    case attempt_fn.() do
      # Error conditions
      {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}} ->
        next_attempt(attempt_fn, opts)
      {:error, %HTTPoison.Error{id: nil, reason: :timeout}} ->
        next_attempt(attempt_fn, opts)
      {:error, %HTTPoison.Error{id: nil, reason: :closed}} ->
        next_attempt(attempt_fn, opts)
      {:error, %HTTPoison.Error{id: nil, reason: _}} = response ->
        handle_errors(attempt_fn, opts, response, :retry_unknown_errors)
      {:ok, %HTTPoison.Response{status_code: 500}} ->
        next_attempt(attempt_fn, opts)
      {:ok, %HTTPoison.Response{status_code: 404}} = response ->
        handle_errors(attempt_fn, opts, response, :include_404s)
      response ->
        response
    end
  end

  def handle_errors(attempt_fn, opts, response, keyword) do
    if Keyword.get(opts, keyword) do
      next_attempt(attempt_fn, opts)
    else
      response
    end
  end

  def next_attempt(attempt, opts) do
    Process.sleep(opts[:wait])
    if opts[:max_attempts] == :infinity || opts[:attempt] < opts[:max_attempts] - 1 do
      opts = Keyword.put(opts, :attempt, opts[:attempt] + 1)
      autoretry(attempt.(), opts)
    else
      attempt.()
    end
  end
end
