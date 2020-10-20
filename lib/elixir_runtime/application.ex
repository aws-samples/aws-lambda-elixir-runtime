# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule ElixirRuntime.Application do
  @moduledoc """
  The main OTP Application for the Elixir Runtime.

  The application consists of two processes: the runtime loop, and the monitor.
  The Runtime process executes the user's code and polls the Lambda Service to
  get function invocations. The Monitor watches the Runtime process and reports
  any errors to the Lambda Service.
  """

  use Application

  def start(_type, _args) do
    children = [
      {
        ElixirRuntime.Monitor.Server,
        [name: ElixirRuntime.Monitor, client: ElixirRuntime.LambdaServiceClient]
      },
      {ElixirRuntime.Loop, [client: ElixirRuntime.LambdaServiceClient]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
