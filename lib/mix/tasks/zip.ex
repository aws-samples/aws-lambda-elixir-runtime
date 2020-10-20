# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule Mix.Tasks.Zip do
  use Mix.Task

  @shortdoc "zip the contents of the current release"
  def run(_) do
    path = release_path(app_name())

    cmd = "cd #{path} && chmod -R +x . && zip -r lambda.zip * && cp lambda.zip #{System.cwd()}"

    System.cmd("sh", ["-c", cmd])
  end

  defp app_name() do
    Mix.Project.config()
    |> Keyword.fetch!(:app)
    |> to_string
  end

  defp release_path(app) do
    "_build/#{Mix.env()}/rel/#{app}/"
  end
end
