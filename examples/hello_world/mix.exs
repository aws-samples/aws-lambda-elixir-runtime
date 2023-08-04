# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.ja
# SPDX-License-Identifier: MIT-0

defmodule HelloWorld.MixProject do
  use Mix.Project

  def project do
    [
      app: :hello_world,
      version: "0.2.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        hello_world: [
          version: "0.2.0",
          applications: [hello_world: :permanent, aws_lambda_elixir_runtime: :permanent],
          include_erts: true,
          include_executables_for: [:unix],

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
