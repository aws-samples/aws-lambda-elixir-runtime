# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule ElixirRuntime.Monitor.Client do
  @moduledoc """
  This module defines the client behavior required by the runtime monitor.
  """

  @type t :: module()
  @type error :: String.t()
  @type id :: String.t()

  @callback init_error(error()) :: no_return
  @callback invocation_error(error(), id()) :: no_return
end
