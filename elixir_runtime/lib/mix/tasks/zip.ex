# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule Mix.Tasks.Lambda.Zip do
  use Mix.Task

  @shortdoc "zip the contents of the current release"
  def run(_) do
    app = app_name()
    version = app_version()
    env = Mix.env()
    release_dir = "_build/#{env}/rel/#{app}"

    cmd = "cd #{release_dir} && \
    chmod +x bin/#{app} && \
    chmod +x releases/#{version}/elixir && \
    chmod +x erts-*/bin/* && \
    zip -r #{app}_lambda.zip * && \
    mv #{app}_lambda.zip ../../../../deploy"

    System.cmd("sh", ["-c", cmd])
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
