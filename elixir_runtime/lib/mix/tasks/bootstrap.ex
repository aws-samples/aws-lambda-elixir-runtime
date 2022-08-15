# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule Mix.Tasks.Lambda.Bootstrap do
  @moduledoc """
  Generate a bootstrap script for the project in the release directory.
  This task will fail if it's run before `mix release`.
  """

  use Mix.Task

  @runtime_libs "aws_lambda_elixir_runtime-0.1.1/priv/system_libraries"

  @shortdoc "Generate a bootstrap script for the project"
  def run(_) do
    app = app_name()
    env = Mix.env()

    path = "_build/#{env}/rel/#{app}/bootstrap"

    Mix.Generator.create_file(path, bootstrap(app))
    File.chmod!(path, 0o777)
  end

  defp app_name() do
    Mix.Project.config()
    |> Keyword.fetch!(:app)
    |> to_string
  end

  # The bootstrap script contents
  defp bootstrap(app) when is_binary(app) do
    """
    \#!/bin/bash

    set -e

    BASE=$(dirname "$0")
    EXE=$BASE/bin/#{app}

    HOME=/tmp
    export HOME

    export LD_PRELOAD="$BASE/lib/#{@runtime_libs}/libcrypto.so.10 $BASE/lib/#{@runtime_libs}/libtinfo.so.5"
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BASE/lib/#{@runtime_libs}

    $EXE start
    """
  end
end
