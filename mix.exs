defmodule Recaptcha.Mixfile do
  use Mix.Project

  @source_url "https://github.com/samueljseay/recaptcha"
  @version "3.1.0"

  def project do
    [
      app: :recaptcha,
      version: @version,
      elixir: "~> 1.6",
      description: description(),
      deps: deps(),
      package: package(),
      docs: docs(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,

      # Test coverage:
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],

      # Dialyzer:
      dialyzer: [
        plt_add_deps: :apps_direct,
        plt_add_apps: [:jason]
      ]
    ]
  end

  def application do
    [extra_applications: [:logger, :eex]]
  end

  defp description do
    """
    A simple reCaptcha package for Elixir applications, provides verification
    and templates for rendering forms with the reCaptcha widget.
    """
  end

  defp deps do
    [
      {:tesla, "~> 1.13"},
      {:jason, "~> 1.2"},
      {:dialyxir, ">= 0.0.0", only: [:dev]},
      {:credo, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: [
        "Samuel Seay",
        "Nikita Sobolev",
        "Michael JustMikey",
        "Manuel Rubio"
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/dymmer-code/recaptcha"}
    ]
  end

  defp docs do
    [
      extras: [
        "CONTRIBUTING.md",
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: @version,
      formatters: ["html"]
    ]
  end
end
