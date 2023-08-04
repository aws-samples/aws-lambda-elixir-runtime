# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule Lambda.MixProject do
  use Mix.Project

  def project do
    [
      app: :aws_lambda_elixir_runtime,
      version: "0.2.0",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: [test: "test --no-start"],

      # Docs
      name: "AWS Lambda Elixir Runtime",
      source_url: "https://github.com/aws-samples/aws-lambda-elixir-runtime",
      homepage_url:
        "https://github.com/aws-samples/aws-lambda-elixir-runtime/tree/master/elixir_runtime",
      docs: [
        source_url_pattern:
          "https://github.com/aws-samples/aws-lambda-elixir-runtime/blob/master/elixir_runtime/%{path}#L%{line}",
        main: "readme",
        extras: [
          "README.md",
          "LICENSE.md"
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {ElixirRuntime.Application, []},
      extra_applications: [:logger, :inets, :ssl]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.4"},
      {:mox, "~> 1.0", only: :test},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:castore, "~> 1.0", only: [:dev, :test]}
    ]
  end

  defp elixirc_paths(:test) do
    ["lib", "test/support"]
  end

  defp elixirc_paths(_) do
    ["lib"]
  end
end
