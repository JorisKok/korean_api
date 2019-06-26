defmodule KoreanApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :korean_api,
      version: "0.1.0",
      elixir: "~> 1.9-rc",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy, :httpoison, :ecto_sql],
      mod: {KoreanApi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:poison, "~> 3.0"},
      {:plug_cowboy, "~> 2.0"},
      {:reverse_proxy_plug, "~> 1.1.1"},
      {:httpoison, "~> 1.4"},
      {:korean_dictionary, "~> 0.1.3"},
      {:korean_sentence_analyser, "~> 0.1.1"},
      # Dev only
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end
end
