# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule Monitor.Error.Test do
  use ExUnit.Case, async: true
  doctest Monitor.Error

  alias Monitor.Error, as: Error

  setup do
    {:current_stacktrace, stacktrace} =
      Process.info(self(), :current_stacktrace)

    formatted = Enum.map(stacktrace, &Exception.format_stacktrace_entry/1)

    [stacktrace: stacktrace, formatted: formatted]
  end

  test "create an error from a function exception", context do
    ex = %RuntimeError{message: "msg"}
    error = Error.from(:function, ex, context.stacktrace)

    assert error.errorMessage === Exception.format(:error, ex)
    assert error.errorType === "FunctionElixir.RuntimeError"
    assert error.stackTrace === context.formatted
  end

  test "create an error from a function exit reason", context do
    reason = {:badarg, context.stacktrace}
    error = Error.from_exit_reason(:function, reason)

    assert error.errorMessage === Exception.format(:error, %ArgumentError{})
    assert error.errorType === "FunctionElixir.ArgumentError"
    assert error.stackTrace === context.formatted
  end

  test "create an error from a runtime exit reason", context do
    reason = {:badarg, context.stacktrace}
    error = Error.from_exit_reason(:runtime, reason)

    assert error.errorMessage === Exception.format(:error, %ArgumentError{})
    assert error.errorType === "RuntimeElixir.ArgumentError"
    assert error.stackTrace === context.formatted
  end

  test "create an error from an unstructured function exit reason" do
    reason = :kill

    expected_exception =
      Exception.normalize(:error, {"unexpected exit", reason})

    error = Error.from_exit_reason(:function, reason)
    assert error.errorMessage === Exception.format(:error, expected_exception)
    assert error.errorType === "FunctionElixir.ErlangError"
    assert error.stackTrace === []
  end

  test "create an error from an unstructured runtime exit reason" do
    reason = :kill

    expected_exception =
      Exception.normalize(:error, {"unexpected exit", reason})

    error = Error.from_exit_reason(:runtime, reason)
    assert error.errorMessage === Exception.format(:error, expected_exception)
    assert error.errorType === "RuntimeElixir.ErlangError"
    assert error.stackTrace === []
  end
end
