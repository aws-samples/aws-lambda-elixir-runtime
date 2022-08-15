# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.ja
# SPDX-License-Identifier: MIT-0

defmodule HelloWorld.MixProject do
  use Mix.Project

  def project do
    [
      app: :hello_world,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      default_release: :aws_lambda_elixir_runtime,
      releases: [
        hello_world: [
          include_executables_for: [:unix],
          applications: [
            runtime_tools: :permanent,
            hello_world: :permanent
          ]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:aws_lambda_elixir_runtime, path: "../../elixir_runtime"}
    ]
  end
end
