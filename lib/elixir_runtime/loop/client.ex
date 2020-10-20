# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule ElixirRuntime.Loop.Client do
  @moduledoc "The Lambda Runtime Service Client behavior this runtime requires"

  @type id :: String.t()
  @type body :: String.t()
  @type context :: Map.t()
  @type invocation :: {id, body, context} | :no_invocation
  @type response :: String.t()

  @callback next_invocation() :: invocation
  @callback complete_invocation(id, response) :: no_return
end
