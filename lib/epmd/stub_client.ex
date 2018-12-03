# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule EPMD.StubClient do
  @moduledoc """
  This module implements an EPMD client which does not actually coordinate
  with the real EPMD or allow the current node to communicate with other
  nodes.
  """

  @doc """
  No need to start a process because the stub client has no state.
  """
  def start_link do
    :ignore
  end

  @doc "family is ignored"
  def register_node(name, port, _family) do
    register_node(name, port)
  end

  @doc "return :ok and a random number"
  def register_node(_name, _port) do
    {:ok, :rand.uniform(3)}
  end

  @doc """
  Return a hardcoded port and version.
  If other nodes were going to be supported this would need to be changed.
  """
  def port_please(_name, _ip) do
    port = 4370
    version = 5
    {:port, port, version}
  end

  @doc """
  There's no way to get the names of all running nodes because this client
  doesn't actually connect to an EPMD instance.
  """
  def names(_hostname) do
    {:error, :address}
  end
end
