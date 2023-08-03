# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule Mix.Tasks.Zip do
  use Mix.Task

  @shortdoc "zip the contents of the current release"
  def run(_) do
    path = release_path(app_name())
    zip_file = "#{app_name()}_lambda.zip"

    cmd = "set -xe && cd #{path} && zip -r #{zip_file} *"

    System.cmd("sh", ["-c", cmd])

    Mix.shell().info("Zip file created: #{Path.join(path, zip_file)}")
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
