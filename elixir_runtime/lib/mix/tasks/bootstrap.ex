# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule Mix.Tasks.Bootstrap do
  @moduledoc """
  Generate a bootstrap script for the project in the release directory.
  This task will fail if it's run before `mix release`.
  """

  use Mix.Task

  @shortdoc "Generate a bootstrap script for the project"
  def run(_) do
    name =
      Mix.Project.config()
      |> Keyword.fetch!(:app)
      |> to_string

    path = "_build/#{Mix.env()}/rel/#{name}/bootstrap"

    Mix.Generator.create_file(path, bootstrap(name))
    File.chmod!(path, 0o777)

    Mix.shell().info("Bootstrap file created: #{path}")

  end

  # The bootstrap script contents
  defp bootstrap(app) when is_binary(app) do
    """
    \#!/bin/sh

    set -x

    BASE=$(dirname "$0")
    EXE=$BASE/bin/#{app}

    HOME=/tmp
    export HOME

    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BASE/lib/#{app_name()}-#{app_version()}/priv"}

    $EXE start
    """
  end

  defp app_name() do
    Mix.Project.config()
    |> Keyword.fetch!(:app)
    |> to_string
  end

  defp app_version() do
    Mix.Project.config()
    |> Keyword.fetch!(:version)
    |> to_string
  end

end
