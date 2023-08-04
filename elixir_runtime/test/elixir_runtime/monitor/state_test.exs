# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule ElixirRuntime.Monitor.State.Test do
  use ExUnit.Case, async: true
  doctest ElixirRuntime.Monitor.State

  alias ElixirRuntime.Monitor
  alias Monitor.State

  defmodule FakeClient do
    @behaviour ElixirRuntime.Monitor.Client

    @impl true
    def init_error(err_msg) do
      send(self(), {:init_error, err_msg})
    end

    @impl true
    def invocation_error(err_msg, id) do
      send(self(), {:invocation_error, err_msg, id})
    end
  end

  test "the monitor's initial state" do
    assert State.initial(FakeClient) === {:not_started, FakeClient}
  end

  test "starting an invocation from the initial state" do
    expected_id = "fakeid"

    result =
      State.initial(FakeClient)
      |> State.start_invocation(expected_id)

    assert result === {:in_progress, expected_id, FakeClient}
  end

  test "report an error from initial state" do
    reason = {:badarg, []}
    expected = Jason.encode!(Monitor.Error.from_exit_reason(:runtime, reason))

    State.initial(FakeClient) |> State.error(reason)

    assert_receive {:init_error, ^expected}
  end

  test "report an error while an invocation is in progress" do
    invoke_id = "fakeid"
    reason = {:badarg, []}
    expected = Jason.encode!(Monitor.Error.from_exit_reason(:function, reason))

    State.initial(FakeClient)
    |> State.start_invocation(invoke_id)
    |> State.error(reason)

    assert_receive {:invocation_error, ^expected, ^invoke_id}
  end
end
