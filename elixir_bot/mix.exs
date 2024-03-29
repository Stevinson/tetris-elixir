defmodule ElixirBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_bot,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.5"},
      {:poison, "~> 4.0.1"},
      # {:matrex, "~> 0.6"},
      {:matrix, "~> 0.3.2"}
    ]
  end
end
