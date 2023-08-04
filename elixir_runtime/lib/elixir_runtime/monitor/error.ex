# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule ElixirRuntime.Monitor.Error do
  @moduledoc """
  This module defines the Error struct which is used to communicate runtime
  errors to the Lambda Runtime Service.
  """

  alias __MODULE__

  @derive Jason.Encoder
  defstruct [
    :errorMessage,
    :errorType,
    :stackTrace
  ]

  @type error_type :: :function | :runtime
  @type error :: %Error{
          errorMessage: String.t(),
          errorType: String.t(),
          stackTrace: list
        }

  @doc "Build an Error from a process-exit reason"
  @spec from_exit_reason(error_type, term) :: error
  def from_exit_reason(error_type, reason)

  def from_exit_reason(error_type, _reason = {error, stacktrace}) do
    exception = Exception.normalize(:error, error, stacktrace)
    build_error(error_name(error_type, exception), exception, stacktrace)
  end

  def from_exit_reason(error_type, reason) do
    exception = Exception.normalize(:error, {"unexpected exit", reason})
    build_error(error_name(error_type, exception), exception, [])
  end

  defp error_name(:function, %{__struct__: name, __exception__: true}) do
    "Function#{name}"
  end

  defp error_name(:runtime, %{__struct__: name, __exception__: true}) do
    "Runtime#{name}"
  end

  defp error_name(:function, _) do
    "FunctionUnknownError"
  end

  defp error_name(:runtime, _) do
    "RuntimeUnknownError"
  end

  defp build_error(error_type, err, stacktrace) do
    %Error{
      errorMessage: Exception.format(:error, err),
      errorType: error_type,
      stackTrace: Enum.map(stacktrace, &Exception.format_stacktrace_entry/1)
    }
  end

  # Old Code

  @doc "Build an Error struct from a runtime error"
  def from(error_type, err, stacktrace) do
    build_error(error_name(error_type, err), err, stacktrace)
  end
end
