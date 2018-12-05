# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule ElixirRuntime.LambdaServiceClient do
  @moduledoc """
  This module represents an HTTP client for the Lambda Runtime service.
  """

  require Logger
  @behaviour ElixirRuntime.Loop.Client
  @behaviour ElixirRuntime.Monitor.Client

  def service_endpoint do
    System.get_env("AWS_LAMBDA_RUNTIME_API")
  end

  @impl true
  @spec invocation_error(
          ElixirRuntime.Monitor.Client.error(),
          ElixirRuntime.Monitor.Client.id()
        ) :: no_return
  def invocation_error(err_msg, id) do
    url =
      'http://#{service_endpoint()}/2018-06-01/runtime/invocation/#{id}/error'

    request = {url, [], 'text/plain', err_msg}
    {:ok, _response} = :httpc.request(:post, request, [], [])
  end

  @impl true
  @spec init_error(Monitor.Client.error()) :: no_return
  def init_error(err_msg) do
    url = 'http://#{service_endpoint()}/2018-06-01/runtime/init/error'
    request = {url, [], 'text/plain', err_msg}
    {:ok, _response} = :httpc.request(:post, request, [], [])
  end

  @impl true
  @spec complete_invocation(
          Runtime.Client.id(),
          Runtime.Client.response()
        ) :: no_return
  def complete_invocation(id, response) do
    url =
      'http://#{service_endpoint()}/2018-06-01/runtime/invocation/#{id}/response'

    request = {url, [], 'text/plain', response}
    {:ok, _response} = :httpc.request(:post, request, [], [])
  end

  @impl true
  @spec next_invocation() :: Runtime.Client.invocation()
  def next_invocation do
    url = 'http://#{service_endpoint()}/2018-06-01/runtime/invocation/next'
    response = :httpc.request(:get, {url, []}, [], [])
    Logger.debug("Http get from #{url} was #{Kernel.inspect(response)}")
    parse(response)
  end

  defp parse(_response = {:ok, {{_, 200, _}, headers, body}}) do
    context = LambdaServiceClient.Context.from_headers(headers)
    {LambdaServiceClient.Context.request_id(context), body, context}
  end

  defp parse(_response) do
    :no_invocation
  end
end

defmodule LambdaServiceClient.Context do
  @request_id "lambda-runtime-aws-request-id"
  @trace_id "lambda-runtime-trace-id"
  @client_context "x-amz-client-context"
  @cognito_identity "x-amz-cognito-identity"
  @deadline_ns "lambda-runtime-deadline-ms"
  @invoked_function_arn "lambda-runtime-invoked-function-arn"

  @known_headers [
    @request_id,
    @trace_id,
    @client_context,
    @cognito_identity,
    @deadline_ns,
    @invoked_function_arn
  ]

  @spec from_headers([{String.t(), String.t()}]) :: Map.t()
  def from_headers(headers) do
    headers
    |> Enum.map(fn {field, value} -> {to_string(field), to_string(value)} end)
    |> Enum.map(fn {field, value} -> {String.downcase(field), value} end)
    |> Enum.filter(fn {field, _} -> field in @known_headers end)
    |> Map.new()
  end

  @spec request_id(Map.t()) :: String.t()
  def request_id(context) when is_map(context) do
    context[@request_id]
  end
end
