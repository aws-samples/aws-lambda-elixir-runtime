# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule Lambda.MixProject do
  use Mix.Project

  def project do
    [
      app: :aws_lambda_elixir_runtime,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: [test: "test --no-start"],

      # Docs
      name: "AWS Lambda Elixir Runtime",
      source_url: "https://github.com/aws-samples/aws-lambda-elixir-runtime",
      homepage_url: "https://github.com/aws-samples/aws-lambda-elixir-runtime/tree/master/elixir_runtime",
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
      extra_applications: [:logger, :inets]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"},
      {:mox, "~> 0.4", only: :test},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp elixirc_paths(:test) do
    ["lib", "test/support"]
  end

  defp elixirc_paths(_) do
    ["lib"]
  end
end
