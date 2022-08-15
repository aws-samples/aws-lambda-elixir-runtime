defmodule HelloWorldTest do
  use ExUnit.Case
  doctest HelloWorld

  test "greets the world" do
    request = %{
      "key1" => "value1",
      "key2" => "value2",
      "key3" => "value3"
    }

    context = %{
      "lambda-runtime-aws-request-id" => "22f56578-dfd6-47f7-8df5-81591dc205e8",
      "lambda-runtime-deadline-ms" => "1567642833715",
      "lambda-runtime-invoked-function-arn" => "arn:aws:lambda:us-west-2:123456789012:function:hello_world",
      "lambda-runtime-trace-id" => "Root=1-5d7054cc-49cf0fdc2501a97e69a4be32;Parent=5de8912c22d2913a;Sampled=0"
    }

    assert HelloWorld.handler(request, context) == :ok
  end
end
