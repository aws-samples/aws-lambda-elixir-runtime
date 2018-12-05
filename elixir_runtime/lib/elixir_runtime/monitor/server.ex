# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule ElixirRuntime.Monitor.Server do
  use GenServer

  alias __MODULE__
  alias ElixirRuntime.Monitor.State, as: State

  def start_link(args) do
    client = Keyword.get(args, :client)
    GenServer.start_link(Server, client, args)
  end

  @impl true
  def init(client) do
    {:ok, State.initial(client)}
  end

  @impl true
  @spec handle_call({:watch, pid}, pid, State.monitor_state()) :: term()
  def handle_call({:watch, pid}, _from, state) do
    Process.monitor(pid)
    {:reply, :ok, state}
  end

  @impl true
  @spec handle_call({atom(), String.t()}, pid, State.monitor_state()) :: term
  def handle_call({:start_invocation, id}, _from, state) do
    {:reply, :ok, State.start_invocation(state, id)}
  end

  @impl true
  @spec handle_call(:reset, pid, State.monitor_state()) :: term
  def handle_call(:reset, _from, state) do
    {:reply, :ok, State.reset(state)}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, _pid, :normal}, state) do
    {:noreply, State.reset(state)}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, _pid, reason}, state) do
    State.error(state, reason)
    {:noreply, State.reset(state)}
  end
end
