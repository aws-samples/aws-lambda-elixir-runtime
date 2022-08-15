# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

import Config

config :logger,
       :console,
       level: :debug,
       metadata: [:module, :function, :line]

# Uncomment to enable environment-specific configuration
# import_config "#{Mix.env()}.exs"
