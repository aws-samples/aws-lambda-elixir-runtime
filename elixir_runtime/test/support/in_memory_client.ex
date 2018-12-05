# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule Support.InMemoryClient do
  @moduledoc """
  This module implements the Monitor.Client and Runtime.Client behaviours and
  is used for testing.
  This client can hold a pending invocation in memory and serve it to the
  runtime for processing.
  """

  alias __MODULE__
  use GenServer
  @behaviour Runtime.Client
  @behaviour Monitor.Client

  @doc "Start the InMemoryClient server"
  def start_link(args) do
    GenServer.start_link(InMemoryClient, args, name: InMemoryClient)
  end

  @impl Runtime.Client
  def next_invocation do
    GenServer.call(InMemoryClient, :next)
  end

  @impl Runtime.Client
  def complete_invocation(id, response) do
    GenServer.call(InMemoryClient, {:complete, id, response})
  end

  @impl Monitor.Client
  def init_error(err_msg) do
    GenServer.call(InMemoryClient, {:init_error, err_msg})
  end

  @impl Monitor.Client
  def invocation_error(err_msg, id) do
    GenServer.call(InMemoryClient, {:invocation_error, err_msg, id})
  end

  # GenServer Callbacks

  @impl true
  def init(args = %{listener: listener, pending: pending})
      when is_pid(listener) and is_list(pending) do
    {:ok, args}
  end

  @impl true
  def handle_call(:next, _from, state = %{pending: []}) do
    send(state.listener, {:next, :no_invocation})
    {:reply, :no_invocation, state}
  end

  @impl true
  def handle_call(:next, _from, state = %{pending: [next | remaining]}) do
    send(state.listener, {:next, next})
    {:reply, next, Map.replace!(state, :pending, remaining)}
  end

  @impl true
  def handle_call(msg, _from, state) do
    send(state.listener, msg)
    {:reply, :ok, state}
  end
end
