# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule Support.FakeInvoke do
  @moduledoc """
  This module defines functions for generating and manipulating fake
  invocations.
  """

  def with_message(message) do
    body = %{msg: message}
    {generated_id(), Poison.encode!(body), %{}}
  end

  def id({id, _body, _context}), do: id
  def body({_id, body, _context}), do: body

  defp generated_id do
    id = Integer.to_string(:random.uniform(100_000_000), 32)
    "TestId-#{id}"
  end
end
