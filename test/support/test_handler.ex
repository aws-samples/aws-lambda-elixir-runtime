# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule TestHandler do
  def echo(body, _context) do
    body["msg"]
  end
end
