# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule Runtime.Handler do
  @moduledoc """
  This module defines the Handler struct which is used to represent the
  module-function atom pair which identifies a client's entrypoint.
  """

  require Logger
  alias __MODULE__

  @enforce_keys [:module, :function]
  defstruct [
    :module,
    :function
  ]

  @doc """
  Manually create a handler from two atoms.
  ## Examples

    iex> Runtime.Handler.new(Elixir.Example, :handle)
    %Runtime.Handler{module: Elixir.Example, function: :handle}
  """
  def new(module, function) when is_atom(module) and is_atom(function) do
    %Handler{module: module, function: function}
  end

  @doc """
  Create a handler from the $_HANDLER environment variable.
  ## Examples

      iex> System.put_env("_HANDLER", "Elixir.Example:handle")
      iex> Runtime.Handler.configured()
      %Runtime.Handler{module: Elixir.Example, function: :handle}
  """
  def configured do
    [module, function] = handler_string() |> String.split(":", trim: true)
    new(String.to_atom(module), String.to_atom(function))
  end

  @doc """
  Invoke the handler function with the body as an argument.
  ## Examples

  Create a handler for String.trim and invoke it to get a result.
      iex> defmodule Example, do: def func(body, _context), do: body
      iex> handler = Runtime.Handler.new(Example, :func)
      iex> handler |> Runtime.Handler.invoke(%{msg: "hello"}, %{})
      %{msg: "hello"}
  """
  def invoke(%Handler{module: module, function: function}, body, context)
      when is_map(body) and is_map(context) do
    Logger.info("invoke #{module}.#{function}(#{Kernel.inspect(body)})")
    Kernel.apply(module, function, [body, context])
  end

  defp handler_string do
    raw = System.get_env("_HANDLER")
    Logger.debug("found handler string '#{raw}'")
    raw
  end
end
