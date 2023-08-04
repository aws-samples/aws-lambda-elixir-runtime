# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule ElixirRuntime.Loop do
  @moduledoc """
  The main Runtime loop process.

  This Process is responsible for polling the Lambda Runtime Service for
  function invocations and invoking the user's code. If this process crashes
  then the Monitor will report the error and stacktrace automatically.
  """

  use Task, restart: :permanent
  require Logger
  alias __MODULE__
  alias Loop.Handler
  alias ElixirRuntime.Monitor

  @type client :: module()

  @doc "spawn a task to run the main loop asynchronously"
  def start_link(args \\ []) do
    client = Keyword.get(args, :client)
    Task.start_link(Loop, :main, [client])
  end

  @doc "the main entrypoint for the runtime"
  @spec main(client()) :: no_return
  def main(client) do
    Monitor.watch(self())
    handler = Handler.configured()
    loop(client, handler)
  end

  @doc "the runtime's main loop"
  def loop(client, handler) do
    Monitor.reset()
    client.next_invocation() |> process(client, handler)
    loop(client, handler)
  end

  defp process(:no_invocation, _client, _handler) do
    Logger.debug("no invocation to process")
    Process.sleep(50)
  end

  defp process(invocation = {id, body, context}, client, handler) do
    Monitor.started(id)
    Logger.info("handle invocation #{Kernel.inspect(invocation)}")

    response =
      handler
      |> Handler.invoke(Jason.decode!(body), context)
      |> Jason.encode!()

    client.complete_invocation(id, response)
  end
end
