# AWS Lambda Elixir Runtime

Example implementation of a custom runtime for running Elixir on AWS Lambda.

## Installation

The package can be installed by adding `aws_lambda_elixir_runtime` to your list
of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:aws_lambda_elixir_runtime, "~> 0.1.0"}
  ]
end
```

## Documentation

Documentation can be generated with
[ExDoc](https://github.com/elixir-lang/ex_doc).

## Step By Step Usage

This section is a step by step for creating the hello world example.

First, create a new mix project in a fresh directory:

```sh
> mix new --app hello_world ./hello_world
```

Now declare a dependency on `:aws_lambda_elixir_runtime` and
`:distillery`, which is used to package the OTP release.

Edit `mix.exs`:

```elixir
def deps do
  [
    {:aws_lambda_elixir_runtime, "~> 0.1.0"},
    {:distillery, "~> 2.0"}
  ]
end
```

Now get the dependencies:

```sh
> mix deps.get
```

The `:aws_lambda_elixir_runtime` has a mix task which will generate a correct
Distillery release file for deploying to Lambda. This is a one-time setup
for the project because once generated the file can be versioned and customized
like any other release. Generate the file like so:

```sh
> mix gen_lambda_release
```

Now the project is ready to be built and deployed -- all that remains is to
actually write a handler function. Open the `lib/hello_world.ex` and edit it
to read:

```elixir
defmodule HelloWorld do

  def my_hello_world_handler(request, context)
      when is_map(request) and is_map(context) do
    """
    Hello World!
    Request: #{Kernel.inspect(request)}
    Context: #{Kernel.inspect(context)}
    """
    |> IO.puts()

    :ok
  end
end
```

This just defines a single public function in the HelloWorld module. Any
public function can be used to handle Lambda invocations, it just needs to
accept two maps.

Now, the project can be built and zipped:

```sh
> mix do release, bootstrap, zip
```

The `release` task is the standard Distillery release operation. The
`bootstrap` task generates an executable shell script which is called by the
AWS Lambda service to start the Elixir OTP application. And the `zip` task just
bundles the contents of the Distillery release into a single zip file.

When this finishes, there should be a `lambda.zip` file in the current
directory. This file can be uploaded to AWS lambda using the AWS console or the
cli. Using the CLI would look like the following:

```sh
> aws lambda create-function \
    --region $AWS_REGION \
    --function-name HelloWorld \
    --handler Elixir.HelloWorld:my_hello_world_handler \
    --role $ROLE_ARN \
    --runtime provided \
    --zip-file fileb://./lambda.zip
```

Once created the function can be invoked from the console, the SDK, or the CLI.
Invoking from the CLI would look like this:

```sh
> aws lambda invoke \
    --function-name HelloWorld \
    --region $AWS_REGION \
    --lag-type TAIL \
    --payload '{"msg": "a fake request"}' \
    outputfile.txt
...

> cat outputfile.txt
Hello World!
Request: %{ "msg" => "a fake request" }
Context: %{ ... }
```

