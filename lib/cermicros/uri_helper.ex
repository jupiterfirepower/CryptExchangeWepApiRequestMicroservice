defmodule Cermicros.UriHelper do
  @moduledoc """
  Cermicros.UriHelper
  """
  def get_domain(url) do
    URI.parse(url).host
    |> String.split(".")
    |> Enum.take(-2)
    |> Enum.join(".")
  end
end
