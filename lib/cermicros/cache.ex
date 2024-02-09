defmodule Cermicros.Cache do
  @moduledoc """
    Redis Cache.
  """
  use Nebulex.Cache,
    otp_app: :cermicros,
    # adapter: Nebulex.Adapters.Cachex
    adapter: NebulexRedisAdapter
end
