#! /bin/bash
mix release
mix lambda.bootstrap
mix lambda.zip
