# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule HelloWorld do
  @moduledoc """
  Entrypoint for my hello world Lambda function.
  """

  require Logger

  @doc """
  The lambda entrypoint is just a public function in a module which accepts
  two maps.

  The returned term will be passed to Poison for Json Encoding.

  ## Examples

    iex> HelloWorld.handler(%{"key" => "value"}, %{"lambda-runtime-aws-request-id" => "1"})
    :ok

  """
  @spec handler(Map.t(), Map.t()) :: Term
  def handler(request, context) when is_map(request) and is_map(context) do
    """
    Hello World!
    Got request #{Kernel.inspect(request)}
    Got Context #{Kernel.inspect(context)}
    """
    |> Logger.info()

    :ok
  end
end
