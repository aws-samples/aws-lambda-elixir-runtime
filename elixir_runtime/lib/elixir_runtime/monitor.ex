# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule ElixirRuntime.Monitor do
  @moduledoc """
  The monitor is responsible for reporting errors in the Elixir process to
  the AWS Lambda runtime service.
  The monitor is a stateful process which tracks the request ID for the
  currently-executing function.
  """

  @behaviour ElixirRuntime.Loop.Monitor

  @doc """
  Tell the monitor server to watch the given process.
  """
  @impl true
  def watch(monitor \\ ElixirRuntime.Monitor, process) when is_pid(process) do
    GenServer.call(monitor, {:watch, process})
  end

  @doc """
  Reset the monitor back to it's initial state, forgetting any currently-known
  ingestor IDs.
  """
  @impl true
  def reset(monitor \\ ElixirRuntime.Monitor) do
    GenServer.call(monitor, :reset)
  end

  @doc """
  Notify the monitor that the runtime loop has started processing an invocation.
  """
  @impl true
  def started(monitor \\ ElixirRuntime.Monitor, id) do
    GenServer.call(monitor, {:start_invocation, id})
  end
end
