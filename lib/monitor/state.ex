# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule Monitor.State do
  @type monitor_state ::
          {:not_started, Monitor.Client.t()}
          | {:in_progress, Monitor.Client.id(), Monitor.Client.t()}

  @doc "the monitor's initial state"
  @spec initial(Monitor.Client.t()) :: monitor_state
  def initial(client) do
    {:not_started, client}
  end

  @doc "start processing an invocation"
  @spec start_invocation(atom(), Monitor.Client.id()) :: monitor_state
  def start_invocation({:not_started, client}, invocation_id) do
    {:in_progress, invocation_id, client}
  end

  @doc "report an error before an invocation was started"
  @spec error(monitor_state, term()) :: no_return
  def error({:not_started, client}, reason) do
    Monitor.Error.from_exit_reason(:runtime, reason)
    |> Poison.encode!()
    |> client.init_error()
  end

  @doc "report an error before an invocation was started"
  @spec error(monitor_state, term()) :: no_return
  def error({:in_progress, id, client}, reason) do
    Monitor.Error.from_exit_reason(:function, reason)
    |> Poison.encode!()
    |> client.invocation_error(id)
  end

  @doc "reset an existing state back to the initial value"
  @spec reset(monitor_state) :: monitor_state
  def reset(from_state) do
    from_state
    |> client()
    |> initial()
  end

  defp client({:in_progress, _, client}), do: client
  defp client({:not_started, client}), do: client
end
