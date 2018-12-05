# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule ElixirRuntime.Application.Test do
  use ExUnit.Case

  # This test suite is for the end-to-end behavior of the elixir runtime
  # application. The tests leverage an in-memory client which echos requests
  # back to the test process for validation.

  def echo_msg(_request = %{"msg" => message}, _context), do: message

  defmodule MyCustomBug do
    defexception [:message]
  end

  def logical_bug_handler(_body, _context) do
    raise MyCustomBug, "a problem"
  end

  setup do
    # clear the _HANDLER var before and after each test
    System.delete_env("_HANDLER")
    on_exit(fn -> System.delete_env("_HANDLER") end)
    []
  end

  test "a single successful invocation" do
    invocation = Support.FakeInvoke.with_message("hello world")
    expected_id = Support.FakeInvoke.id(invocation)

    System.put_env("_HANDLER", "Elixir.ElixirRuntime.Application.Test:echo_msg")
    start_with_invocations([invocation])

    assert_receive {:next, ^invocation}
    assert_receive {:complete, ^expected_id, "\"hello world\""}
  end

  test "a handler with a logical error" do
    invoke = Support.FakeInvoke.with_message("some message")
    expected_id = Support.FakeInvoke.id(invoke)

    System.put_env(
      "_HANDLER",
      "Elixir.ElixirRuntime.Application.Test:logical_bug_handler"
    )

    start_with_invocations([invoke])

    assert_receive {:invocation_error, msg, ^expected_id}

    assert String.contains?(
             msg,
             "FunctionElixir.ElixirRuntime.Application.Test.MyCustomBug"
           )
  end

  test "a missing handler string" do
    start_with_invocations([Support.FakeInvoke.with_message("not used")])

    assert_receive {:init_error, msg}, 500
    assert String.contains?(msg, "RuntimeElixir.FunctionClauseError")
  end

  test "a malformed handler string" do
    System.put_env("_HANDLER", "Elixir.Application.Test.this_isnt_right")
    start_with_invocations([Support.FakeInvoke.with_message("not used")])

    assert_receive {:init_error, msg}
    assert String.contains?(msg, "RuntimeElixir.MatchError")
  end

  test "a missing handler implementation" do
    invoke = Support.FakeInvoke.with_message("I'll never be handled")
    expected_id = Support.FakeInvoke.id(invoke)

    System.put_env("_HANDLER", "Elixir.Application.Test:doesnt_exist")
    start_with_invocations([invoke])

    assert_receive {:invocation_error, msg, ^expected_id}
    assert String.contains?(msg, "FunctionElixir.UndefinedFunctionError")
  end

  # Launch the components of the application
  # 1. start the InMemoryClient with the provided invocations, if any
  # 2. start the Monitor.Server named Monitor
  # 3. start the Runtime task
  # This is the same process as starting the application but it's done
  # piece-by-piece here so the InMemoryClient can be passed into the Runtime
  # and monitor.
  defp start_with_invocations(invocations) do
    start_supervised!(
      {Support.InMemoryClient, %{pending: invocations, listener: self()}}
    )

    start_supervised!({
      ElixirRuntime.Monitor.Server,
      [client: Support.InMemoryClient, name: ElixirRuntime.Monitor]
    })

    start_supervised!({ElixirRuntime.Loop, [client: Support.InMemoryClient]})
  end
end
