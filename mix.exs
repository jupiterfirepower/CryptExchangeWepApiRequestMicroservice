defmodule Cermicros.MixProject do
  use Mix.Project

  def project do
    [
      app: :cermicros,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [ # add releases configuration
       cermicros: [ # we can name releases anything, this will be prod's config
           include_executables_for: [:unix], # we'll be deploying to Linux only
           steps: [:assemble, :tar] # have Mix automatically create a tarball after assembly
         ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :cowboy, :plug],
      mod: {Cermicros.Application, []},
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 2.1.0"},
      {:gen_retry, "~> 1.2.0"},
      {:ex_url, "~> 2.0.0"},
      {:jason, "~> 1.4.1"},
      {:gen_stage, "~> 1.0.0"},
      {:nebulex, "~> 2.5.2"},
      {:nebulex_adapters_cachex, "~> 2.1.1"},
      {:nebulex_redis_adapter , "~> 2.3.1"},
      {:kaffe, "~> 1.18.0"},
      {:plug, "~> 1.14"},
      {:plug_cowboy, "~> 2.6.1"},
      #{:snappyer, "~> 1.2.9"},
      {:distillery, "~> 2.1"},
    ]
  end
end
