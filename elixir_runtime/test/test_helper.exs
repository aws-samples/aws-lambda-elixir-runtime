# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

Mox.defmock(FakeRuntimeClient, for: ElixirRuntime.Loop.Client)
Mox.defmock(FakeMonitorClient, for: ElixirRuntime.Monitor.Client)

Application.ensure_all_started(:mox)

ExUnit.start()
