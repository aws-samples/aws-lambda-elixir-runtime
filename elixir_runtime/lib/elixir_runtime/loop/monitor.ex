# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule ElixirRuntime.Loop.Monitor do
  @moduledoc """
  The Runtime requires a stateful monitor which will observe any
  failures and call the proper backend APIs.
  """

  @doc "Tell the monitor to start watching this process"
  @callback watch(pid()) :: no_return

  @doc """
  Tell the monitor that the runtime has started processing an invocation.
  """
  @callback started(Runtime.Client.id()) :: no_return

  @doc """
  Tell the monitor that the runtime is starting over fresh and no
  invocation is in progress.
  """
  @callback reset() :: no_return
end
