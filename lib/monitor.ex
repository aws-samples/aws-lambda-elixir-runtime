# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule Monitor do
  @moduledoc """
  The monitor is responsible for reporting errors in the Elixir process to
  the AWS Lambda runtime service.
  The monitor is a stateful process which tracks the request ID for the
  currently-executing function.
  """

  @behaviour Runtime.Monitor

  alias __MODULE__

  @impl true
  def watch(monitor \\ Monitor, process) do
    GenServer.call(monitor, {:watch, process})
  end

  @impl true
  def reset(monitor \\ Monitor) do
    GenServer.call(monitor, :reset)
  end

  @impl true
  def started(monitor \\ Monitor, id) do
    GenServer.call(monitor, {:start_invocation, id})
  end
end
